//
//  ZHFVUserModel.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/10.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVUserModel.h"

@implementation ZHFVUserModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    ZHFVUserModel *model = [ZHFVUserModel new];
    model.accessToken = [dic objectForKey:@"accessToken"];
    model.expiresIn = [dic objectForKey:@"expiresIn"];
    model.refreshToken = [dic objectForKey:@"refreshToken"];
    model.userAuthenticationOpenid = [dic objectForKey:@"userAuthenticationOpenid"];
    model.userAuthenticationOverdueTime = [dic objectForKey:@"userAuthenticationOverdueTime"];
    model.userAuthenticationTime = [dic objectForKey:@"userAuthenticationTime"];
    model.userHeadPortrait = [dic objectForKey:@"userHeadPortrait"];
    model.userNickname = [dic objectForKey:@"userNickname"];
    return model;
}
@end
