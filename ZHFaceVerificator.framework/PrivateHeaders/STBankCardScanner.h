//
//  STBankCardController.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/9.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCardScannerController.h"
#import "STBankCardRecognizer.h"
#import "STBankCardView.h"
#import "STScanEnumHeader.h"

/*!
 @protocol STBankCardScannerDelegate

 @abstract
    定义了 STBankCardScanner 的代理，接收 STBankCardScanner 回调的扫描结果或扫描中出现的异常。
 */
@protocol STBankCardScannerDelegate <NSObject>

@required

/*!
 @method receivedBankCardResult:

 @abstract  在收到扫描结果时调用

 @param bankCard  银行卡信息的识别结果

 */
- (void)receivedBankCardResult:(STBankCard *)bankCard requestId:(NSString *)requestId;

/*!
 @method receivedBankCardError:

 @abstract  出现错误时的回调函数

 @param errorCode  不同错误的错误代码
 @param requestId 请求ID

 @discussion
 无请求 ID 时，requestId 为 @""
 */
- (void)receivedBankCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId;

@optional

/**
 云端识别开始的回调方法
 */
- (void)receivedOnlineCheckBegin;

/**
 处理在 Demo 中点击取消键后的操作
 */
- (void)didCancel;

@end

@interface STBankCardScanner : STCardScannerController <STBankCardRecognizerDelegate, STCardScanViewDelegate>

@property (nonatomic, weak) id<STBankCardScannerDelegate> bankCardScannerDelegate;

/**
 银行卡识别类
 */
@property (nonatomic, strong) STBankCardRecognizer *bankCardRecognizer;

/*!
 @property isScanVerticalCard

 @abstract 扫描竖版银行卡的开关

 @discussion
    当该属性为 YES 时，为扫描竖版银行卡。
    当该属性为 NO 时，为扫描横版银行卡
    该属性默认为 NO
 */
@property (nonatomic, assign) BOOL isScanVerticalCard;


/*!
 @method initWithOrientation:apiKey:apiSecret:
 @abstract STBankCardScanner 的包含扫描方向及 apiKey 和 apiSecret 的初始化方法。

 @param orientation 视频的初始化方向

 @param apiKey 用户账户的 ApiKey

 @param apiSecret 用户账户的 ApiSecret

 @param delegate  回调代理

 @return 银行卡扫描实例

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
                           delegate:(id<STBankCardScannerDelegate, STCardScannerControllerDelegate>)delegate;



/*!
 @method moveScanWindowUpFromCenterWithDelta:
 @abstract 调整取景框的位置
 用于开发者自定义取景框，从中央上上下移动是为了在不同屏幕上的适配问题(仅限于竖屏)用于和定义的界面保持一致

 @param delta 取景框从中央位置上下移动的偏移量

 @discussion
    <0：     取景框从中央位置上移

    >0：     取景框从中央位置下移
*/
- (void)moveScanWindowUpFromCenterWithDelta:(NSInteger)delta;

@end
