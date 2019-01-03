//
//  ZHFVUserModel.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/10.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHFVUserModel : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *expiresIn;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *userAuthenticationOpenid;
@property (nonatomic, copy) NSString *userAuthenticationOverdueTime;
@property (nonatomic, copy) NSString *userAuthenticationTime;
@property (nonatomic, copy) NSString *userHeadPortrait;
@property (nonatomic, copy) NSString *userNickname;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
