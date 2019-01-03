//
//  ZHFVImageUploader.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVImageUploader.h"
#import "OSSService.h"
#import "NSDataAdditions.h"



NSString *const AliyunAccessKeyID = @"LTAI0MPX9Qip5Olf";
NSString *const AliyunAccessKeySecret = @"k5LatVrUJ6EYGW2QdrThAm8eZWMfNf";
NSString *const OSS_BUCKET_PRIVATE = @"rmt-face";
NSString *const OSS_ENDPOINT = @"oss-cn-hangzhou.aliyuncs.com";
NSString *const OSS_IMAGE_URL_PRIFIX = @"https://rmt-face.oss-cn-hangzhou.aliyuncs.com/";

@interface ZHFVImageUploader()

@property (nonatomic, strong) OSSClient *defaultClient;


@end


@implementation ZHFVImageUploader

+(instancetype)shareInstance
{
    static dispatch_once_t pred;
    __strong static ZHFVImageUploader *shareObject = nil;
    dispatch_once(&pred, ^{
        shareObject = [self new];
    });
    return shareObject;
}

- (void)setUp{
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKeyID secretKey:AliyunAccessKeySecret];
    OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
    cfg.maxRetryCount = 2;
    cfg.timeoutIntervalForRequest = 30;
    cfg.isHttpdnsEnable = NO;
    cfg.crc64Verifiable = YES;
    OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credential clientConfiguration:cfg];
    self.defaultClient = defaultClient;
}




- (void)uploadImagesWithUserToken:(NSString *)token frontImage:(NSData *)frontImage backImage:(NSData *)backImage success:(void (^)(NSString * _Nullable frontUrl,NSString * _Nullable backUrl))success failure:(void (^)(NSError * _Nonnull error))failure
{
    __block NSString *frontUrl;
    __block NSString *backUrl;
    __block NSString *errorString = @"";
    dispatch_queue_t queue = dispatch_queue_create("com.AILife.resouceQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t queueGroup= dispatch_group_create();
    dispatch_group_async(queueGroup, queue, ^{
        dispatch_group_enter(queueGroup);
        [self uploadImageWithUserToken:token imageData:frontImage success:^(NSString * _Nullable url) {
            frontUrl = url;
            dispatch_group_leave(queueGroup);
        } failure:^(NSError * _Nonnull error) {
            errorString = [errorString stringByAppendingString:@"    正面图片上传失败"];
            dispatch_group_leave(queueGroup);
        }];
        dispatch_group_enter(queueGroup);
        [self uploadImageWithUserToken:token imageData:backImage success:^(NSString * _Nullable url) {
            backUrl = url;
            dispatch_group_leave(queueGroup);
        } failure:^(NSError * _Nonnull error) {
            errorString = [errorString stringByAppendingString:@"    反面图片上传失败"];
            dispatch_group_leave(queueGroup);
        }];
    });
    
    dispatch_group_notify(queueGroup, queue, ^{
        if(errorString.length>0){
            if (failure) {
                failure([NSError errorWithDomain:errorString code:-1 userInfo:nil]);
            }
        }else{
            if (success) {
                success(frontUrl,backUrl);
            }
        }
    });
}


- (void)uploadImageWithUserToken:(NSString *)token imageData:(NSData *)image success:(void (^)(NSString * _Nullable url))success failure:(void (^)(NSError * _Nonnull error))failure {
    
    NSString *objectKey = [NSString stringWithFormat:@"customer/%@/%@.png",token,[image dataMd5]];
    if (![objectKey oss_isNotEmpty]) {
        NSError *error = [NSError errorWithDomain:NSInvalidArgumentException code:0 userInfo:@{NSLocalizedDescriptionKey: @"objectKey should not be nil"}];
        failure(error);
        return;
    }
    OSSPutObjectRequest *normalUploadRequest = [OSSPutObjectRequest new];
    normalUploadRequest.bucketName = OSS_BUCKET_PRIVATE;
    normalUploadRequest.objectKey = objectKey;
    normalUploadRequest.uploadingData = image;
    normalUploadRequest.isAuthenticationRequired = YES;
    normalUploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float progress = 1.f * totalByteSent / totalBytesExpectedToSend;
        OSSLogDebug(@"上传文件进度: %f", progress);
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSTask * task = [self.defaultClient putObject:normalUploadRequest];
        [task continueWithBlock:^id(OSSTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (task.error) {
                    failure(task.error);
                } else
                {
                    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",OSS_IMAGE_URL_PRIFIX,objectKey];
                    success(fileUrl);
                }
            });
            
            return nil;
        }];
    });
}
@end
