//
//  STBankCardController.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/9.
//  Copyright © 2017年 SenseTime. All rights reserved.
//
#import "STDefineHeader.h"
#import "STBankCardScanner.h"
#import "STBankCardRecognizer.h"
#import "ZHFVConst.h"
NSInteger const STBankCardScannerScanBoundary = 64;

@interface STBankCardScanner ()

@property (nonatomic, strong) STBankCardView *bankCardScanView;

@property (strong, nonatomic) NSOperationQueue *mainQueue;

@end

@implementation STBankCardScanner

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoCaptureManger setVideoOrientation:self.captureOrientation];
    self.bankCardScanView = [[STBankCardView alloc] initWithFrame:self.view.bounds
                                                      windowFrame:super.uiWindowRect
                                                      orientation:super.interfaceOrientation];
    self.bankCardScanView.cardScanViewDelegate = self;
    self.bankCardRecognizer.bankCardRecognizerDelegate = self;
    self.isScanVerticalCard = _isScanVerticalCard;
    self.videoCaptureManger.cardRecognizer = self.bankCardRecognizer;
    [self.view addSubview:self.bankCardScanView];
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


- (instancetype)initWithOrientation:(AVCaptureVideoOrientation)orientation
                             apiKey:(NSString *)apiKey
                          apiSecret:(NSString *)apiSecret
                           delegate:(id<STBankCardScannerDelegate, STCardScannerControllerDelegate>)delegate {
    self = [super initWithOrientation:orientation];
    if (!self) {
        return self;
    }
    if (_bankCardScannerDelegate != delegate) {
        _bankCardScannerDelegate = delegate;
    }
    if (self.cardScannerControllerDelegate != delegate) {
        self.cardScannerControllerDelegate = delegate;
    }
    _mainQueue = [NSOperationQueue mainQueue];
    NSBundle *bundle = FrameworkBundle;
    NSString *licensePath = [bundle pathForResource:@"card_orc" ofType:@"lic"];
    NSString *resourcesBundlePath = OCR_SDK_ResourceBundle;

    if (resourcesBundlePath) {
        NSString *modelPath =
            [NSString pathWithComponents:@[resourcesBundlePath, @"Model", @"M_Ocr_Bankcard_Mobile.model"]];
        _bankCardRecognizer = [[STBankCardRecognizer alloc] initWithBankCardModelPath:modelPath
                                                                          licensePath:licensePath
                                                                               apiKey:apiKey
                                                                            apiSecret:apiSecret
                                                                             delegate:self];
    }
    return self;
}

- (void)setIsScanVerticalCard:(BOOL)isScanVerticalCard {
    _isScanVerticalCard = isScanVerticalCard;
    self.videoCaptureManger.isScanVerticalCard = isScanVerticalCard;
    if (!isScanVerticalCard && self.captureOrientation == AVCaptureVideoOrientationPortrait) {
        self.videoCaptureManger.scanVideoWindowRect = VIDEO_WINDOW_H;
        [self.bankCardScanView changeScanWindowDirection:NO];
    } else if (isScanVerticalCard) {
        [self.videoCaptureManger setVideoOrientation:AVCaptureVideoOrientationPortrait];
        self.videoCaptureManger.scanVideoWindowRect = MASK_WINDOW_VERTICALCARD;
        super.captureOrientation = AVCaptureVideoOrientationPortrait;
        [self.bankCardScanView changeScanWindowDirection:YES];
    }
}

- (void)scannerReceivedBankCardResult:(STBankCard *)bankCard requestId:(NSString *)requestId {
    [self.mainQueue addOperationWithBlock:^{
        if (self.bankCardScannerDelegate &&
            [self.bankCardScannerDelegate respondsToSelector:@selector(receivedBankCardResult:requestId:)]) {
            [self.bankCardScannerDelegate receivedBankCardResult:bankCard requestId:requestId];
        }
    }];
}

- (void)scannerReceivedBankCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId {
    [self.mainQueue addOperationWithBlock:^{
        if (self.bankCardScannerDelegate &&
            [self.bankCardScannerDelegate respondsToSelector:@selector(receivedBankCardError:requestId:)]) {
            [self.bankCardScannerDelegate receivedBankCardError:errorCode requestId:requestId];
        }
    }];
}

- (void)scannerReceivedOnlineCheckBegin {
    [self.mainQueue addOperationWithBlock:^{
        if (self.bankCardScannerDelegate &&
            [self.bankCardScannerDelegate respondsToSelector:@selector(receivedOnlineCheckBegin)]) {
            [self.bankCardScannerDelegate receivedOnlineCheckBegin];
        }
    }];
}

- (void)moveScanWindowUpFromCenterWithDelta:(NSInteger)moveDelta {
    if (self.isScanVerticalCard ||
        !(self.videoCaptureManger.captureVideoOrientation == AVCaptureVideoOrientationPortrait)) {
        return;
    }
    CGFloat realHeight = SCREEN_HEIGHT;
    NSInteger moveValue = moveDelta;
    BOOL ismoveValueNagative = moveValue < 0;

    if ((self.bankCardScanView.windowFrame.origin.y + moveValue) < STBankCardScannerScanBoundary &&
        ismoveValueNagative) {
        moveValue = -self.bankCardScanView.windowFrame.origin.y + STBankCardScannerScanBoundary;
    }
    if ((self.bankCardScanView.windowFrame.origin.y + self.bankCardScanView.windowFrame.size.height + moveValue +
             STBankCardScannerScanBoundary >
         realHeight) &&
        !ismoveValueNagative) {
        moveValue = realHeight - self.bankCardScanView.windowFrame.origin.y -
            self.bankCardScanView.windowFrame.size.height - STBankCardScannerScanBoundary;
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
    [self.bankCardScanView moveWindowDeltaY:moveValue];
}

- (void)didCancel {
    [self.mainQueue addOperationWithBlock:^{
        if (self.bankCardScannerDelegate && [self.bankCardScannerDelegate respondsToSelector:@selector(didCancel)]) {
            [self.bankCardScannerDelegate didCancel];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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
