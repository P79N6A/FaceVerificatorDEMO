//
//  ZHFVImageUploader.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface ZHFVImageUploader : NSObject
- (void)setUp;
+(instancetype)shareInstance;
///上传2张
- (void)uploadImagesWithUserToken:(NSString *)token frontImage:(NSData *)frontImage backImage:(NSData *)backImage success:(void (^)(NSString * _Nullable frontUrl,NSString * _Nullable backUrl))success failure:(void (^)(NSError * _Nonnull error))failure;
///一张上传
- (void)uploadImageWithUserToken:(NSString *)token imageData:(NSData *)image success:(void (^)(NSString * _Nullable url))success failure:(void (^)(NSError * _Nonnull error))failure;

@end

NS_ASSUME_NONNULL_END
