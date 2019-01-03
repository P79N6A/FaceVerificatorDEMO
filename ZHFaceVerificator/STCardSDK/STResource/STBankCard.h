//
//  STBankCard.h
//  lib_st_bankcard
//
//  Created by Zhou Shuyan on 6/28/15.
//  Copyright (c) 2015 SenseTime. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*! @brief STBankCard 类
 *
 * 该类为银行卡结果的 Model 类，存储扫描出银行卡结果的信息集。
 */
@interface STBankCard : NSObject

/*!
 @property bankCardNumber

 @abstract 银行卡号
 */
@property (nonatomic, strong) NSString *bankCardNumber;

/*!
 @property bankName

 @abstract 发卡行名称
 */
@property (nonatomic, strong) NSString *bankName;

/*!
 @property bankIdentificationNumber

 @abstract 发卡行标识代码
 */
@property (nonatomic, strong) NSString *bankIdentificationNumber;

/*!
 @property bankCardName

 @abstract 卡片名称
 */
@property (nonatomic, strong) NSString *bankCardName;

/*!
 @property bankCardType

 @abstract 卡片类型
 */
@property (nonatomic, strong) NSString *bankCardType;

/*!
 @property bankCardImage

 @abstract 扫描出的银行卡图片
 */
@property (nonatomic, strong) UIImage *bankCardImage;

/**
 银行卡卡号在结果图上的位置
 */
@property (nonatomic, assign) CGRect bankCardNumberRect;

/*!
 @property bankCardOriginImage

 @abstract 摄像头捕捉的原始图片
 */
@property (nonatomic, strong) UIImage *bankCardOriginImage;

/*!
 @property bankCardScanDuration

 @abstract 银行卡扫描时长
 */
@property (nonatomic, strong) NSString *bankCardScanDuration;

@end
