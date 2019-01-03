//
//  ZHFVNetworkManager.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>



FOUNDATION_EXPORT NSString *const ZHFV_NETWORK_HOST;




NS_ASSUME_NONNULL_BEGIN
@class STIdCard;
@interface ZHFVNetworkManager : NSObject

/**
 用户登录

 @param data 用户识别的图像
 @param uploadProgress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)requestUserVerifactionWithUploadData:(NSData *)data
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 获取验证码

 @param phoneNum 手机号
 @param uploadProgress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)requestGetCodeForPhone:(NSString *)phoneNum
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 注册

 @param phoneNum 手机号
 @param code 验证码
 @param uploadProgress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)requestRegistForPhone:(NSString *)phoneNum
                         code:(NSString *)code
                     progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;




/**
 上传图片

 @param frontIDCard 前面的
 @param backIDCard 身份证背面图片
 @param identity ID
 @param token token
 @param uploadProgress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)requestPostIDCard:(STIdCard *)frontIDCard
               backIDCard:(STIdCard *)backIDCard
                 userInfo:(NSString *)identity
                    token:(NSString *)token
                 progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



+ (void)requestPostUserHeader:(NSData *)header
                       userID:(NSString *)userID
                        token:(NSString *)token
                     progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
                     ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (void)requestPostUserNick:(NSString *)userNick
                       userID:(NSString *)userID
                        token:(NSString *)token
                     progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
                     ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



/**
 结束注册流程

 @param idnumber 身份证号
 @param name m姓名
 @param cloudID 活体检测公有云ID
 @param token  token
 @param imageData  活体检测的第一张图片
 @param uploadProgres 进度
 @param success 成功
 @param failure 失败
 */
+ (void)finishRegist:(NSString *)idnumber
                name:(NSString *)name
         cloudDataID:(NSString *)cloudID
               token:(NSString *)token
               image:(NSData *)imageData
            progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
            ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



/**
 刷新token

 @param oldToken 旧的token
 @param uploadProgres 进度
 @param success 成功
 @param failure 失败
 */
+ (void)refreshToken:(NSString *)oldToken
              openid:(NSString *)userAuthenticationOpenid
            progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
            ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;




/**
 验证人脸（动态、静态）

 @param accessToken <#accessToken description#>
 @param image_file <#image_file description#>
 @param userAuthenticationOpenid <#userAuthenticationOpenid description#>
 @param userPhotoUrl <#userPhotoUrl description#>
 @param uploadProgres <#uploadProgres description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
+ (void)userFaceVerificationwWithToken:(NSString *)accessToken
                             imageFile:(NSData *)image_file
              userAuthenticationOpenid:(NSString *)userAuthenticationOpenid
                              progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
                              ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
