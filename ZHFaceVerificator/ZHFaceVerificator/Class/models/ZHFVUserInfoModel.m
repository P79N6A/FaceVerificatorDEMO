//
//  ZHFVUserInfoModel.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVUserInfoModel.h"

@implementation ZHFVUserInfoModel
+ (instancetype)modelWithDictionary:(NSDictionary *)dic{
    ZHFVUserInfoModel *model = [ZHFVUserInfoModel new];
    model.access_token = [dic objectForKey:@"access_token"];
    model.token_type = [dic objectForKey:@"token_type"];
    model.refresh_token = [dic objectForKey:@"refresh_token"];
    model.expires_in = [dic objectForKey:@"expires_in"];
    model.scope = [dic objectForKey:@"scope"];
    model.iat = [dic objectForKey:@"iat"];
    model.jti = [dic objectForKey:@"jti"];
    return model;
}
@end
