//
//  STBankCardRecognizer.h
//  GeneralOCRSDK
//
//  Created by zhanghenan on 2017/10/19.
//  Copyright © 2017年 Sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "STBankCard.h"
#import "STOCREnumTypeHeader.h"

@protocol STBankCardRecognizerDelegate <NSObject>

/**
 将错误码回传至 STBankCardScanner 的代理方法

 @param requestId 请求ID

 @discussion
 无请求 Id 时，requestId 为 @""
 */
- (void)scannerReceivedBankCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId;

/**
 将扫描结果回传至 STBankCardScanner 的代理方法

 @param bankCard 扫描结果
 @param requestId 请求Id

 @discussion
 无请求 Id 时，requestId 为 @""
 */
- (void)scannerReceivedBankCardResult:(STBankCard *)bankCard requestId:(NSString *)requestId;

/**
 云端识别开始的回调方法
 */
- (void)scannerReceivedOnlineCheckBegin;

@end

@interface STBankCardRecognizer : NSObject

@property (nonatomic, weak) id<STBankCardRecognizerDelegate> bankCardRecognizerDelegate;

/**
 STBankCardRecognizer 的初始化方法

 @param modelPath 银行卡模型文件路径
 @param licensePath 授权文件路径
 @param apiKey 用户的 ApiKey
 @param apiSecret 用户的 ApiSecret
 @param delegate 回调代理
 @return STBankCardRecognizer 的实例
 */
- (instancetype)initWithBankCardModelPath:(NSString *)modelPath
                              licensePath:(NSString *)licensePath
                                   apiKey:(NSString *)apiKey
                                apiSecret:(NSString *)apiSecret
                                 delegate:(id<STBankCardRecognizerDelegate>)delegate;

/**
 从视频流中识别银行卡的方法

 @param sampleBuffer 视频流
 @param scanRect 扫描框位置(视频流中的位置)
 */
- (void)bankCardRecognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer scanWindowVideoRect:(CGRect)scanRect;

/**
 设置扫描超时时间

 @param timeoutSecond 超时时间，时间单位为秒。

 @discussion
 当 timeoutSecond 设置为 0 时，即扫描超时时间为无限长。默认值为 15.
 */
- (void)setTimeoutSeconds:(NSTimeInterval)timeoutSeconds;

/**
 获取当前 SDK 的版本

 @return 版本号
 */
+ (NSString *)getVersion;

/**
 取消银行卡识别
 */
- (void)cancelBankCardRecognize;
@end
