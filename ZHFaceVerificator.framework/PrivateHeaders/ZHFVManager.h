//
//  ZHFVManager.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/2.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#import "AILBaseViewController.h"
#import "ZHFVUserInfoController.h"
#import "ZHFVIDCardController.h"
#import "ZHFVRegistController.h"
#import "ZHFVUserModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    ZHFVFaceVerifyTypeStatic,
    ZHFVFaceVerifyTypeDynamic
}ZHFVFaceVerifyType;


@protocol ZHFVLoginDelegate <NSObject>
@required;
///注册、登陆成功回调
- (void)userLoginComplete:(ZHFVUserModel *)userInfo error:(NSError *)error;

@end

@protocol ZHFVVerifyDelegate <NSObject>

///验证成功回调
- (void)userFaceVerfifyComplete:(id)responseObj  error:(NSError *)error;

@end



@interface ZHFVManager : NSObject
+(instancetype)shareInstance;

+ (void)setUpWithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret;

@property (nonatomic, copy ,readonly) NSString *appkey;

@property (nonatomic, copy ,readonly) NSString *appSecret;

@property (nonatomic, weak ,readonly) UIViewController <ZHFVLoginDelegate>*delegate;



/**
 登录/注册流程
 1，活体检测
 2，判断是否有注册，有注册直接登录，未注册进入3
 3，绑定手机号
 4，上传身份证
 5，比对身份证和人脸信息，设置昵称、头像
 6，登录

 @param delegate 代理
 @return 返回注册主控制器
 */
+ (UIViewController *)faceVerificatorWithRegistStepsWithDelegate:(id <ZHFVLoginDelegate>)delegate;



/**
 续签

 @param oldSession 旧的token
 @param completeBlock 完成回调
 */
+ (void)refreshToken:(NSString *)oldSession openID:(NSString *)openID complete:(void(^)(id responseObject))completeBlock;

///单步人脸验证
+ (UIViewController *)easyFaceVerificatorForUser:(ZHFVUserModel *)user delegate:(id <ZHFVVerifyDelegate>)delegate;
///四步人脸验证
+ (UIViewController *)hardFaceVerificatorForUser:(ZHFVUserModel *)user delegate:(id <ZHFVVerifyDelegate>)delegate;





@end

NS_ASSUME_NONNULL_END
