//
//  ZHFVNetworkManager.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVNetworkManager.h"
#import "AFNetworking.h"
#import "STIdCard.h"
#import "NSDataAdditions.h"
#import "ZHFVImageUploader.h"
#import "ZHFVLocationManager.h"
#import "ZHFVManager.h"





NSString *const ZHFV_NETWORK_HOST = @"http://api.face.renmaituan.com";

NSString *const ZHFV_NETWORK_SIGN_IN = @"/face/api/login-verification/user-face-verification-login";//验证人脸--登录
NSString *const ZHFV_NETWORK_GET_CODE = @"/uaa/api/send-captcha";//发送短信
NSString *const ZHFV_NETWORK_REGIST = @"/api/token/sms-face";//验证短信
NSString *const ZHFV_NETWORK_POST_ID_CARD = @"/uaa/api/user-authentication/scan-idcard";//扫面身份证
NSString *const ZHFV_NETWORK_SET_HEAD = @"/uaa/api/user-extra-infos/sets-head-portrait";//设置head
NSString *const ZHFV_NETWORK_SET_NICK = @"/uaa/api/user-extra-infos/sets-nickname";//上传
NSString *const ZHFV_NETWORK_FINISH_REGIST = @"/face/api/register/identity/liveness_idnumber_verification";//结束注册流程

NSString *const ZHFV_NETWORK_VERIFICATION = @"/face/api/user-verification/user-face-verification";
NSString *const ZHFV_NETWORK_REFRESH_TOKEN = @"/developer/api/app-user-authentication/user-face-refresh-token";


@interface ZHFVNetworkManager()<NSURLSessionDelegate>

@end

@implementation ZHFVNetworkManager


#pragma mark - 验证是否能登录

+ (NSMutableDictionary *)defaultPostDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"APPLE" forKey:@"gatherTerminal"];
    [dic setValue:@([ZHFVLocationManager shareInstance].latitude) forKey:@"latitude"];
    [dic setValue:@([ZHFVLocationManager shareInstance].longitude) forKey:@"longitude"];
    [dic setValue:[ZHFVManager shareInstance].appkey forKey:@"appKey"];
    [dic setValue:[ZHFVManager shareInstance].appSecret forKey:@"appSecret"];
    return dic;
}

+ (void)requestUserVerifactionWithUploadData:(NSData *)data
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    [[ZHFVImageUploader shareInstance]uploadImageWithUserToken:@"face" imageData:data success:^(NSString * _Nullable url) {
        
        NSMutableDictionary *dictionary = [self defaultPostDictionary];
        [dictionary setObject:@"1111" forKey:@"face_authorization"];
        [dictionary setObject:url forKey:@"userPhotoUrl"];
        AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
        NSString *requestUrl = [NSString stringWithFormat:@"%@%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_SIGN_IN];
        [manage POST:requestUrl parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
         {
             [formData appendPartWithFileData:data name:@"image_file" fileName:[NSString stringWithFormat:@"%@.%@",@"userimage",@"png"] mimeType:@"image/jpeg"];
         } progress:uploadProgress success:success failure:failure];
        
    } failure:^(NSError * _Nonnull error) {
        failure(nil,error);
    }];
}

#pragma mark - 获取验证码
+ (void)requestGetCodeForPhone:(NSString *)phoneNum
                      progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_GET_CODE];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNum forKey:@"mobile"];
    [dic setObject:@"SMS" forKey:@"sendCaptchaTypeEnum"];
    [dic setObject:@"REGISTER_LOGIN" forKey:@"systemCaptchaTypeEnum"];
    
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage POST:url parameters:dic progress:uploadProgress success:success failure:failure];
}

#pragma mark - 注册
+ (void)requestRegistForPhone:(NSString *)phoneNum
                         code:(NSString *)code
                     progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_REGIST];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNum forKey:@"mobile"];
    [dic setObject:code forKey:@"captcha"];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage POST:url parameters:dic progress:uploadProgress success:success failure:failure];
}



#pragma mark - 上传身份证
///上传到图床
+ (void)requestPostIDCard:(STIdCard *)frontIDCard
               backIDCard:(STIdCard *)backIDCard
                 userInfo:(NSString *)identity
                    token:(NSString *)token
                 progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                  success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [[ZHFVImageUploader shareInstance]uploadImagesWithUserToken:identity frontImage:UIImagePNGRepresentation(frontIDCard.idCardFrontImage) backImage:UIImagePNGRepresentation(backIDCard.idCardBackImage) success:^(NSString * _Nullable frontUrl, NSString * _Nullable backUrl)
     {
         NSLog(@"%@\n%@",frontUrl,backUrl);
         [ZHFVNetworkManager requestPostIDCardAfterImageUploaded:frontIDCard backIDCard:backIDCard token:token frontUrl:frontUrl backUrl:backUrl progress:uploadProgress success:success failure:failure];
    } failure:^(NSError * _Nonnull error) {
        [ZHFVNetworkManager showError:error.domain];
    }];
}

+ (void)requestPostIDCardAfterImageUploaded:(STIdCard *)frontIDCard
                                 backIDCard:(STIdCard *)backIDCard
                                      token:(NSString *)token
                                   frontUrl:(NSString *)frontUrl
                                    backUrl:(NSString *)backUrl
                                   progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgress
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_POST_ID_CARD];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:frontIDCard.idCardAddress forKey:@"idCardAddress"];
    [dic setObject:frontIDCard.idCardAuthority forKey:@"idCardAuthority"];
    [dic setObject:backUrl forKey:@"idCardBackImage"];
    [dic setObject:backUrl forKey:@"idCardBackOriginImage"];
    [dic setObject:frontUrl forKey:@"idCardFrontImage"];
    [dic setObject:frontUrl forKey:@"idCardFrontOriginImage"];
    [dic setObject:frontIDCard.idCardDay forKey:@"idCardDay"];
    [dic setObject:frontIDCard.idCardGender forKey:@"idCardGender"];
    [dic setObject:frontIDCard.idCardId forKey:@"idCardId"];
    [dic setObject:frontIDCard.idCardMonth forKey:@"idCardMonth"];
    [dic setObject:frontIDCard.idCardName forKey:@"idCardName"];
    [dic setObject:frontIDCard.idCardNation forKey:@"idCardNation"];
    [dic setObject:frontIDCard.idCardValidity forKey:@"idCardValidity"];
    [dic setObject:frontIDCard.idCardYear forKey:@"idCardYear"];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    [manage.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    [manage POST:url parameters:dic progress:uploadProgress success:success failure:failure];
}

+ (void)requestPostUserHeader:(NSData *)header
                       userID:(NSString *)userID
                        token:(NSString *)token
                     progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
                     ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [[ZHFVImageUploader shareInstance]uploadImageWithUserToken:userID imageData:header success:^(NSString * _Nullable imageurl)
     {
         NSString *requestUrl = [NSString stringWithFormat:@"%@%@?head_portrait=%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_SET_HEAD,imageurl];
         AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
         manage.requestSerializer = [AFJSONRequestSerializer serializer];
         [manage.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
         [manage POST:requestUrl parameters:@{@"head_portrait":imageurl} progress:uploadProgres success:success failure:failure];
    } failure:^(NSError * _Nonnull error) {
        failure(nil,error);
    }];
}

+ (void)requestPostUserNick:(NSString *)userNick
                     userID:(NSString *)userID
                      token:(NSString *)token
                   progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
                   ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    [manage.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@?nickname=%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_SET_NICK,userNick];
    requestUrl = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userNick forKey:@"nickname"];
    [manage POST:requestUrl parameters:parameters progress:uploadProgres success:success failure:failure];
}


+ (void)finishRegist:(NSString *)idnumber
                name:(NSString *)name
         cloudDataID:(NSString *)cloudID
               token:(NSString *)token
               image:(NSData *)imageData
            progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
            ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@?idnumber=%@&livenessId=%@&name=%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_FINISH_REGIST,idnumber,cloudID,name];
    requestUrl = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.requestSerializer = [AFJSONRequestSerializer serializer];
    [manage.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:idnumber forKey:@"idnumber"];
    [dic setObject:cloudID forKey:@"livenessId"];
    [dic setObject:name forKey:@"name"];
    [manage POST:requestUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *md5 = [imageData dataMd5];
        [formData appendPartWithFileData:imageData name:@"image_file" fileName:[NSString stringWithFormat:@"%@.%@",md5,@"png"] mimeType:@"image/jpeg"];
    } progress:uploadProgres success:success failure:failure];
}

+ (void)refreshToken:(NSString *)oldToken
              openid:(NSString *)userAuthenticationOpenid
            progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
            ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
   
    NSString *requestUrl = [NSString  stringWithFormat:@"%@%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_REFRESH_TOKEN];

    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:oldToken forKey:@"refreshToken"];
    [dic setObject:userAuthenticationOpenid forKey:@"userAuthenticationOpenid"];
    [dic setObject:[ZHFVManager shareInstance].appkey forKey:@"appKey"];
    [dic setObject:[ZHFVManager shareInstance].appSecret forKey:@"appSecret"];
    [manage POST:requestUrl parameters:dic progress:uploadProgres success:success failure:failure];
}



+ (void)userFaceVerificationwWithToken:(NSString *)accessToken
                             imageFile:(NSData *)image_file
              userAuthenticationOpenid:(NSString *)userAuthenticationOpenid
                              progress:(nullable void (^)(NSProgress * _Nonnull progress))uploadProgres
                              ssuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *dic = [ZHFVNetworkManager defaultPostDictionary];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",ZHFV_NETWORK_HOST,ZHFV_NETWORK_VERIFICATION];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [dic setObject:userAuthenticationOpenid forKey:@"userAuthenticationOpenid"];
    [dic setObject:accessToken forKey:@"accessToken"];
    [dic setObject:@"" forKey:@"userPhotoUrl"];
    [manage POST:requestUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *md5 = [image_file dataMd5];
        [formData appendPartWithFileData:image_file name:@"image_file" fileName:[NSString stringWithFormat:@"%@.%@",md5,@"png"] mimeType:@"image/jpeg"];
    } progress:uploadProgres success:success failure:failure];
}




#pragma mark - tools
+ (void)showError:(NSString *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc]initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    });
}
@end
