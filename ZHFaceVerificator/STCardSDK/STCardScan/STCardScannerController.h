//
//  STCardScannerController.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/3.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STVideoCapture.h"
#import "STVideoCaptureManger.h"
#import "STCardScanView.h"
#import "STOCREnumTypeHeader.h"
#import "AILBaseViewController.h"
@protocol STCardScannerControllerDelegate <NSObject>
@optional;
- (void)receiveDeveiceError:(STIDOCRDeveiceError)deveiceError;

@end

/**
 银行卡扫描及身份证扫描的父类 Controller
 */
@interface STCardScannerController : AILBaseViewController

@property (nonatomic, weak) id<STCardScannerControllerDelegate> cardScannerControllerDelegate;
@property (nonatomic, strong) STVideoCapture *videoCapture;
@property (nonatomic, strong) STVideoCaptureManger *videoCaptureManger;
@property (nonatomic, strong) STCardScanView *videoCaptureView;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *apiSecret;
@property (nonatomic, assign) CGRect uiWindowRect;
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, assign) AVCaptureVideoOrientation captureOrientation;

- (instancetype)initWithOrientation:(AVCaptureVideoOrientation)orientation;

- (void)moveScanWindowUpFromCenterWithDelta:(NSInteger)delta;

//- (void)receiveErrorCode:(NSInteger)errorCode;
@end
