//
//  ZHFVLocationManager.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZHFVLocationManager : NSObject
+(instancetype)shareInstance;
- (void)startUpdataLocate;
@property (nonatomic,assign,readonly) double latitude;//经度
@property (nonatomic,assign,readonly) double longitude;//维度


@end

NS_ASSUME_NONNULL_END
