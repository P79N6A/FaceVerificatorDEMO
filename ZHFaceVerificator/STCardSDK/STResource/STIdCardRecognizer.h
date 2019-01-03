//
//  STIdCardRecognizer.h
//  GeneralOCRSDK
//
//  Created by zhanghenan on 2017/10/19.
//  Copyright © 2017年 Sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "STOCREnumTypeHeader.h"
#import "STIdCard.h"

@protocol STIdCardRecognizerDelegate <NSObject>

/**
 将扫描结果回传至 STIdCardScanner 的代理方法

 @param IdCard 扫描结果
 @param requestId 请求Id
 */
- (void)scannerReceivedIdCardResult:(STIdCard *)IdCard requestId:(NSString *)requestId;

/**
 将错误码回传至 STIdCardScanner 的代理方法

 @param errorCode 错误码类型
 @param requestId 请求Id

 @discussion
 无请求 Id 时，requestId 为 @""
 */
- (void)scannerReceivedIdCardError:(STIDOCRResult)errorCode requestId:(NSString *)requestId;

/**
 云端识别开始的回调方法
 */
- (void)scannerReceivedOnlineCheckBegin;

- (void)scannerReceivedFirstSideScanFinish:(STIdCardSide)cardSide;

@end

@interface STIdCardRecognizer : NSObject

@property (nonatomic, weak) id<STIdCardRecognizerDelegate> idCardRecognizerDelegate;

/**
 STIdCardRecognizer 身份证的初始化方法

 @param modelPath 身份证模型文件路径
 @param licensePath 授权文件路径
 @param apiKey 用户的 ApiKey
 @param apiSecret 用户的 ApiSecret
 @param delegate 回调代理
 @return STIdCardRecognizer 的实例
 */
- (instancetype)initWithIdCardModelPath:(NSString *)modelPath
                            licensePath:(NSString *)licensePath
                                 apiKey:(NSString *)apiKey
                              apiSecret:(NSString *)apiSecret
                               delegate:(id<STIdCardRecognizerDelegate>)delegate;

/**
 从视频流中识别身份证的方法

 @param sampleBuffer sampleBuffer 视频流
 @param scanRect scanRect 扫描框位置(视频流中的位置)
 */
- (void)idCardRecognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer scanWindowVideoRect:(CGRect)scanRect;

/**
 设置扫描模式

 @param scanMode 单面或双面扫描
 @param scanSide 正面反面或任意面扫描
 @param itemOption 识别字段的选择

 @discussion
 itemOption
 需要与设置的扫描面相对应，如设置单面正面扫描时设置反面识别字段则为非法参数，如设置双面扫描则需设置正面字段+反面字段。如无特殊需求，推荐设置
 STIdCardItemAll
 */
- (void)setScanMode:(STIdCardScanMode)scanMode
               scanSide:(STIdCardScanSide)scanSide
    recognizeItemOption:(STIdCardItemOption)itemOption;

/**
 设置扫描超时时间

 @param timeoutSecond 超时时间，时间单位为秒。

 @discussion
 当 timeoutSeconds 设置为 0 时，即扫描超时时间为无限长。默认值为 15.
 */
- (void)setTimeoutSeconds:(NSTimeInterval)timeoutSeconds;

/**
 设置允许扫描结果中身份证图片最大的缺失比百分比

 @param percentAge 允许最大的缺失百分比(范围: [0, 100], 100表示关闭此项检测)

 @discussion
 默认缺失比百分比为 5
 */
- (void)setImageMaxLossPrecentage:(NSInteger)percentAge;

/**
 获取版本号

 @return 当前版本号的字符串
 */
+ (NSString *)getVersion;

/**
 取消身份证识别
 */
- (void)cancelIdCardRecognize;

@end
