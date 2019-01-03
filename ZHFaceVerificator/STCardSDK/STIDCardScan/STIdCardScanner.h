//
//  STIdCardScanner.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/15.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCardScannerController.h"
#import "STIdCard.h"
#import "STScanEnumHeader.h"
#import "STIdCardView.h"
#import "STIdCardRecognizer.h"

/*!
 @protocol STIdCardScannerDelegate

 @abstract
 定义了 STIdCardScanner 的代理，接收 STIdCardScanner 回调的扫描结果或扫描中出现的异常。
 */
@protocol STIdCardScannerDelegate <NSObject>

@required

- (void)receivedIdCardResult:(STIdCard *)idCard requestId:(NSString *)requestId;

/*!
 @method receivedBankCardError:

 @abstract  出现错误时的回调函数

 @param errorCode  不同错误的错误代码
 @param requestId 请求ID

 @discussion
 无请求 ID 时，requestId 为 @""
 */
- (void)receivedIdCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId;

@optional

/**
 连续正反面模式中，第一面扫描成功后调用

 @param cardSide 扫描结果的身份证朝向
 */
- (void)receivedFirstSideScanFinish:(STIdCardSide)cardSide;

/**
 云端识别开始的回调方法
 */
- (void)receivedOnlineCheckBegin;

/**
 处理在 Demo 中点击取消键后的操作
 */
- (void)didCancel;

@end

@interface STIdCardScanner : STCardScannerController <STIdCardRecognizerDelegate, STCardScanViewDelegate>

@property (nonatomic, weak) id<STIdCardScannerDelegate> idCardScannerDelegate;

/**
 身份证识别类
 */
@property (nonatomic, strong) STIdCardRecognizer *idCardRecognizer;

/**
    控制扫描身份证的模式：
 */
/**
    选择扫描出结果后输出的结果
 */
@property (nonatomic, assign) STIdCardItemOption scanItemOption;

/**
 STIdCardScanner 的 View
 */
@property (nonatomic, strong) STIdCardView *idCardScanView;


/*!
 @method initWithOrientation:apiKey:apiSecret:
 @abstract STIdCardScanner 的包含扫描方向及 apiKey 和 apiSecret 的初始化方法。

 @param orientation 视频的初始化方向

 @param apiKey 用户账户的 ApiKey

 @param apiSecret 用户账户的 ApiSecret

 @param delegate  回调代理

 @return 身份证扫描实例

 @discussion
 初始化方向支持：

 AVCaptureVideoOrientationPortrait

 AVCaptureVideoOrientationLandscapeRight

 AVCaptureVideoOrientationLandscapeLeft

 这三种视频初始化方向
 */
- (instancetype)initWithOrientation:(AVCaptureVideoOrientation)orientation
                             apiKey:(NSString *)apiKey
                          apiSecret:(NSString *)apiSecret
                           delegate:(id<STIdCardScannerDelegate, STCardScannerControllerDelegate>)delegate;



/*!
 @method moveScanWindowUpFromCenterWithDelta:
 @abstract 调整取景框的位置
 用于开发者自定义取景框，从中央上上下移动是为了在不同屏幕上的适配问题(仅限于竖屏)用于和定义的界面保持一致

 @param moveDelta 取景框从中央位置上下移动的偏移量

 @discussion
 <0：     取景框从中央位置上移

 >0：     取景框从中央位置下移
 */
- (void)moveScanWindowUpFromCenterWithDelta:(NSInteger)moveDelta;

@end
