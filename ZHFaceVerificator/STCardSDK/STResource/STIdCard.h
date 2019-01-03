//
//  STIdCard.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/14.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STScanEnumHeader.h"
#import <UIKit/UIKit.h>

@interface STIdCard : NSObject
// Foreground Content

/**
 姓名
 */
@property (nonatomic, strong, ) NSString *idCardName;

/**
 性别
 */
@property (nonatomic, strong, ) NSString *idCardGender;

/**
 民族
 */
@property (nonatomic, strong, ) NSString *idCardNation;

/**
 出生年
 */
@property (nonatomic, strong, ) NSString *idCardYear;

/**
 出生月
 */
@property (nonatomic, strong, ) NSString *idCardMonth;

/**
 出生日
 */
@property (nonatomic, strong, ) NSString *idCardDay;

/**
 住址
 */
@property (nonatomic, strong, ) NSString *idCardAddress;

/**
 公民身份证号
 */
@property (nonatomic, strong, ) NSString *idCardId;

// Background Content

/**
 签发机关
 */
@property (nonatomic, strong, ) NSString *idCardAuthority;

/**
 有效期
 */
@property (nonatomic, strong, ) NSString *idCardValidity;

/**
 身份证扫描面
 */
@property (nonatomic, assign) STIdCardScanSide cardScanSide;

/**
 身份证类型
 */
@property (nonatomic, assign) STIdCardType cardType;

/**
 身份证识别关键字
 */
@property (nonatomic, assign) STIdCardItemOption cardItemOption;

/**
 身份证扫描流程模式
 */
@property (nonatomic, assign) STIdCardScanMode cardScanMode;

/**
 身份证正面来源信息
 */
@property (nonatomic, assign) STCardClassify frontImageClassify;

/**
 身份证背面来源信息
 */
@property (nonatomic, assign) STCardClassify backImageClassify;

/**
 扫描身份证结果的身份证朝向，在连续扫描正反面时，该属性为第二次扫描结果的身份证朝向
 */
@property (nonatomic, assign) STIdCardSide cardSide;

// Image of Card & Face

/**
 身份证正面结果图片
 */
@property (nonatomic, strong) UIImage *idCardFrontImage;

/**
 身份证背面结果图片
 */
@property (nonatomic, strong) UIImage *idCardBackImage;

/**
 摄像头捕捉的正面原始图片
 */
@property (nonatomic, strong) UIImage *idCardFrontOriginImage;

/**
 摄像头捕捉的背面原始图片
 */
@property (nonatomic, strong) UIImage *idCardBackOriginImage;

/**
 身份证姓名在身份证图片中的位置
 */
@property (nonatomic, assign) CGRect rectName;

/**
 身份证号在身份证图片中的位置
 */
@property (nonatomic, assign) CGRect rectIdNumber;

/**
 人脸图在身份证图片中的位置
 */
@property (nonatomic, assign) CGRect rectPhotoImage;

/**
 身份证扫描时长
 */
@property (nonatomic, strong) NSString *idCardScanDuration;

@end
