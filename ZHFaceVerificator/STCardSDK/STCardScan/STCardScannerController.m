
//
//  STCardScannerController.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/3.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCardScannerController.h"
#import "STScanEnumHeader.h"
#import "STDefineHeader.h"

typedef void (^propertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface STCardScannerController ()

@end

@implementation STCardScannerController

#pragma mark - life cycle

- (instancetype)initWithOrientation:(AVCaptureVideoOrientation)orientation {
    self = [super init];
    if (self) {
        _captureOrientation = orientation;
        _videoCapture = [[STVideoCapture alloc] init];
        _videoCaptureManger = [[STVideoCaptureManger alloc] init];
        [_videoCaptureManger setVideoOrientation:orientation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)loadView {
    [super loadView];
    [self.videoCapture addCaptureOutput:self.videoCaptureManger.captureVideoOutput];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    self.view.layer.masksToBounds = YES;
    self.view.contentMode = UIViewContentModeScaleAspectFill;

    AVCaptureVideoPreviewLayer *previewLayer =
        [AVCaptureVideoPreviewLayer layerWithSession:self.videoCapture.captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
    previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view.layer addSublayer:previewLayer];

    [self addNotificationToCaptureDevice:self.videoCapture.captureDevice];
    [self addView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (granted) {
                                             [self start];

                                         } else {
                                             NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
                                             [mainQueue addOperationWithBlock:^{
                                                 [self receiveErrorCode:STIDOCR_E_CAMERA];
                                             }];
                                         }
                                     }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            [self start];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            [self receiveErrorCode:STIDOCR_E_CAMERA];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addView {
    CGRect uiWindowScanRect;
    CGRect videoWindowScanRect;
    switch (self.captureOrientation) {
        case AVCaptureVideoOrientationPortrait: {
            videoWindowScanRect = [self.videoCaptureManger getMaskFrame];
            uiWindowScanRect =
                CGRectMake(videoWindowScanRect.origin.x / self.videoCaptureManger.videoWidth * SCREEN_WIDTH,
                           videoWindowScanRect.origin.y / self.videoCaptureManger.videoHeight * SCREEN_HEIGHT,
                           videoWindowScanRect.size.width / self.videoCaptureManger.videoWidth * SCREEN_WIDTH,
                           videoWindowScanRect.size.height / self.videoCaptureManger.videoHeight * SCREEN_HEIGHT);
            self.interfaceOrientation = UIInterfaceOrientationPortrait;
        } break;
        case AVCaptureVideoOrientationLandscapeLeft: {
            videoWindowScanRect = [self.videoCaptureManger getMaskFrame];
            uiWindowScanRect =
                CGRectMake(videoWindowScanRect.origin.y / self.videoCaptureManger.videoHeight * SCREEN_WIDTH,
                           videoWindowScanRect.origin.x / self.videoCaptureManger.videoWidth * SCREEN_HEIGHT,
                           videoWindowScanRect.size.height / self.videoCaptureManger.videoHeight * SCREEN_WIDTH,
                           videoWindowScanRect.size.width / self.videoCaptureManger.videoWidth * SCREEN_HEIGHT);
            self.interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        } break;
        case AVCaptureVideoOrientationLandscapeRight: {
            videoWindowScanRect = [self.videoCaptureManger getMaskFrame];
            uiWindowScanRect =
                CGRectMake(videoWindowScanRect.origin.y / self.videoCaptureManger.videoHeight * SCREEN_WIDTH,
                           videoWindowScanRect.origin.x / self.videoCaptureManger.videoWidth * SCREEN_HEIGHT,
                           videoWindowScanRect.size.height / self.videoCaptureManger.videoHeight * SCREEN_WIDTH,
                           videoWindowScanRect.size.width / self.videoCaptureManger.videoWidth * SCREEN_HEIGHT);
            self.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        } break;

        default: {
            videoWindowScanRect = [self.videoCaptureManger getMaskFrame];
            uiWindowScanRect =
                CGRectMake(videoWindowScanRect.origin.x / self.videoCaptureManger.videoWidth * SCREEN_WIDTH,
                           videoWindowScanRect.origin.y / self.videoCaptureManger.videoHeight * SCREEN_HEIGHT,
                           videoWindowScanRect.size.width / self.videoCaptureManger.videoWidth * SCREEN_WIDTH,
                           videoWindowScanRect.size.height / self.videoCaptureManger.videoHeight * SCREEN_HEIGHT);
            self.interfaceOrientation = UIInterfaceOrientationPortrait;
        } break;
    }
    self.uiWindowRect = uiWindowScanRect;
}

- (void)start {
    if (!self.videoCapture.captureSession.isRunning) {
        [self.videoCapture.captureSession startRunning];
    }
}

- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice { //! OCLint
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled = YES;
    }];
}

- (void)changeDeviceProperty:(propertyChangeBlock)propertyChange {
    if (!propertyChange) {
        return;
    }
    AVCaptureDevice *captureDevice = [self.videoCapture.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    } else {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@", error.localizedDescription);
    }
}

- (void)receiveErrorCode:(STIDOCRDeveiceError)errorCode {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        if (self.cardScannerControllerDelegate &&
            [self.cardScannerControllerDelegate respondsToSelector:@selector(receiveDeveiceError:)]) {
            [self.cardScannerControllerDelegate receiveDeveiceError:errorCode];
        }
    }];
}

#pragma mark - Forbid Rotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; //只支持这一个方向(正常的方向)
}

- (void)moveScanWindowUpFromCenterWithDelta:(NSInteger)delta { //! OCLint
    if (!(self.captureOrientation == AVCaptureVideoOrientationPortrait)) {
        return;
    }
}

@end
