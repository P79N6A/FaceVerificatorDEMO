//
//  ZHFVUserInfoModel.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHFVUserInfoModel : NSObject
+ (instancetype)modelWithDictionary:(NSDictionary *)dic;

@property (nonatomic, strong)NSString *access_token;
@property (nonatomic, strong)NSString *token_type;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic, strong)NSString *expires_in;
@property (nonatomic, strong)NSString *scope;
@property (nonatomic, strong)NSString *iat;
@property (nonatomic, strong)NSString *jti;
//身份
@property (nonatomic, strong) NSString *identity;

@end

NS_ASSUME_NONNULL_END
