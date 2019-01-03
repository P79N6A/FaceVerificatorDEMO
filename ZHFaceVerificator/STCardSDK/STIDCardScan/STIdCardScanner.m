//
//  STIdCardScanner.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/15.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STIdCardScanner.h"
#import "STDefineHeader.h"
#import "ZHFVConst.h"

NSInteger const STIdCardScannerScanBoundary = 64;

@interface STIdCardScanner ()

@property (strong, nonatomic) NSOperationQueue *mainQueue;

@end

@implementation STIdCardScanner


- (instancetype)initWithOrientation:(AVCaptureVideoOrientation)orientation
                             apiKey:(NSString *)apiKey
                          apiSecret:(NSString *)apiSecret
                           delegate:(id<STIdCardScannerDelegate, STCardScannerControllerDelegate>)delegate {
    self = [super initWithOrientation:orientation];
    if (!self) {
        return self;
    }
    if (_idCardScannerDelegate != delegate) {
        _idCardScannerDelegate = delegate;
    }
    if (self.cardScannerControllerDelegate != delegate) {
        self.cardScannerControllerDelegate = delegate;
    }
    _mainQueue = [NSOperationQueue mainQueue];

    NSBundle *bundle = FrameworkBundle;
    NSString *licensePath = [bundle pathForResource:@"card_orc" ofType:@"lic"];
    NSString *resourcesBundlePath = OCR_SDK_ResourcePath;
    if (resourcesBundlePath) {
        NSString *modelPath =
            [NSString pathWithComponents:@[resourcesBundlePath, @"Model", @"M_Ocr_Idcard_Mobile.model"]];
        _idCardRecognizer = [[STIdCardRecognizer alloc] initWithIdCardModelPath:modelPath
                                                                    licensePath:licensePath
                                                                         apiKey:apiKey
                                                                      apiSecret:apiSecret
                                                                       delegate:self];
    }
    _idCardRecognizer.idCardRecognizerDelegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoCaptureManger setVideoOrientation:self.captureOrientation];
    //    self.videoCaptureManger.cardScanSide= self.scanCardSide;
    self.videoCaptureManger.scanIdCardItemOption = self.scanItemOption;
    self.idCardScanView = [[STIdCardView alloc] initWithFrame:self.view.bounds
                                                  windowFrame:super.uiWindowRect
                                                  orientation:super.interfaceOrientation];
    self.idCardScanView.cardScanViewDelegate = self;
    self.videoCaptureManger.cardRecognizer = self.idCardRecognizer;
    [self.view addSubview:self.idCardScanView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Recognizer Delegate


- (void)scannerReceivedIdCardResult:(STIdCard *)idCard requestId:(NSString *)requestId {
    [self.mainQueue addOperationWithBlock:^{
        if (self.idCardScannerDelegate &&
            [self.idCardScannerDelegate respondsToSelector:@selector(receivedIdCardResult:requestId:)]) {
            [self.idCardScannerDelegate receivedIdCardResult:idCard requestId:requestId];
        }
    }];
}

- (void)scannerReceivedIdCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId {
    [self.mainQueue addOperationWithBlock:^{
        if (self.idCardScannerDelegate &&
            [self.idCardScannerDelegate respondsToSelector:@selector(receivedIdCardError:requestId:)]) {
            [self.idCardScannerDelegate receivedIdCardError:errorCode requestId:requestId];
        }
    }];
}

- (void)scannerReceivedOnlineCheckBegin {
    [self.mainQueue addOperationWithBlock:^{
        if (self.idCardScannerDelegate &&
            [self.idCardScannerDelegate respondsToSelector:@selector(receivedOnlineCheckBegin)]) {
            [self.idCardScannerDelegate receivedOnlineCheckBegin];
        }
    }];
}


- (void)scannerReceivedFirstSideScanFinish:(STIdCardSide)cardSide {
    [self.mainQueue addOperationWithBlock:^{
        if (self.idCardScannerDelegate &&
            [self.idCardScannerDelegate respondsToSelector:@selector(receivedFirstSideScanFinish:)]) {
            [self.idCardScannerDelegate receivedFirstSideScanFinish:cardSide];
        }
    }];
}

- (void)moveScanWindowUpFromCenterWithDelta:(NSInteger)moveDelta {
    if (!(self.videoCaptureManger.captureVideoOrientation == AVCaptureVideoOrientationPortrait)) {
        return;
    }
    CGFloat realHeight = SCREEN_HEIGHT;
    NSInteger moveValue = moveDelta;

    BOOL ismoveValueNagative = moveValue < 0;

    if ((self.idCardScanView.windowFrame.origin.y + moveValue) < STIdCardScannerScanBoundary && ismoveValueNagative) {
        moveValue = -self.idCardScanView.windowFrame.origin.y + STIdCardScannerScanBoundary;
    }
    if ((self.idCardScanView.windowFrame.origin.y + self.idCardScanView.windowFrame.size.height + moveValue +
             STIdCardScannerScanBoundary >
         realHeight) &&
        !ismoveValueNagative) {
        moveValue = realHeight - self.idCardScanView.windowFrame.origin.y -
            self.idCardScanView.windowFrame.size.height - STIdCardScannerScanBoundary;
    }

    if ((self.videoCaptureManger.scanVideoWindowRect.origin.y +
         (CGFloat) moveValue / realHeight * (CGFloat) self.videoCaptureManger.videoHeight) < 0) {
        moveValue = -1 * self.videoCaptureManger.scanVideoWindowRect.origin.y /
            (CGFloat) self.videoCaptureManger.videoHeight * realHeight;
    }

    if ((self.videoCaptureManger.scanVideoWindowRect.origin.y +
             (CGFloat) moveValue / realHeight * (CGFloat) self.videoCaptureManger.videoHeight +
             self.videoCaptureManger.scanVideoWindowRect.size.height >
         (CGFloat) self.videoCaptureManger.videoHeight)) {
        moveValue = realHeight -
            self.videoCaptureManger.scanVideoWindowRect.origin.y / (CGFloat) self.videoCaptureManger.videoHeight *
                realHeight;
    }

    CGRect tmpRect = self.videoCaptureManger.scanVideoWindowRect;
    if (self.videoCaptureManger.videoHeight > self.videoCaptureManger.videoWidth) {
        NSInteger iFitIPhone4Size = 0;
        // For fit ip4 ratio
        if (realHeight == 480) {
            iFitIPhone4Size = 200;
        }
        tmpRect.origin.y +=
            (CGFloat) moveValue / realHeight * ((CGFloat) self.videoCaptureManger.videoHeight - iFitIPhone4Size);
    }
    self.videoCaptureManger.scanVideoWindowRect = tmpRect;
    [self.idCardScanView moveWindowDeltaY:moveValue];
}

- (void)didCancel {
    if (self.idCardScannerDelegate && [self.idCardScannerDelegate respondsToSelector:@selector(didCancel)]) {
        [self.idCardScannerDelegate didCancel];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)willResignActive {
    if ([self isCurrentViewOnScreen] && self.cardScannerControllerDelegate &&
        [self.cardScannerControllerDelegate respondsToSelector:@selector(receiveDeveiceError:)]) {
        [self.cardScannerControllerDelegate receiveDeveiceError:STIDOCR_WILL_RESIGN_ACTIVE];
    }
}

- (BOOL)isCurrentViewOnScreen {
    return self.isViewLoaded && self.view.window;
}
@end
