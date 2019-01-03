//
//  ZHFVManager.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/2.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVManager.h"
#import "ZHFVLocationManager.h"
#import "ZHFVImageUploader.h"
#import "ZHFVEntryViewController.h"
#import "ZHFVNetworkManager.h"
#import "ZHFVRegistController.h"
#import "ZHFVConst.h"
#import "STLivenessController.h"
#import "ZHFVFinishRegistAlertView.h"
@interface ZHFVManager()<STLivenessDetectorDelegate, STLivenessControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, copy)NSString *appkey;

@property (nonatomic, copy)NSString *appSecret;

@property (nonatomic, weak) id <ZHFVLoginDelegate>loginDelegate;
@property (nonatomic, weak) id <ZHFVVerifyDelegate>verifyDelegate;
@property (nonatomic, strong)UIView *indicatorView;

@property (nonatomic, strong)UIActivityIndicatorView *indicator;

@property (nonatomic, strong) ZHFVUserModel *loginUser;

@property (nonatomic, strong) ZHFVUserModel *verifyUser;

@property (nonatomic, weak) STLivenessController *verifyVC;

@end


@implementation ZHFVManager

+(instancetype)shareInstance
{
    static dispatch_once_t pred;
    __strong static ZHFVManager *shareObject = nil;
    dispatch_once(&pred, ^{
        shareObject = [self new];
    });
    return shareObject;
}

+ (void)setUpWithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret{
    [[ZHFVManager shareInstance]setUpWithAppkey:appkey appSecret:appSecret];
}

- (void)setUpWithAppkey:(NSString *)appkey appSecret:(NSString *)appSecret;
{
    self.appkey = appkey;
    self.appSecret = appSecret;
    [[ZHFVLocationManager shareInstance]startUpdataLocate];
    [[ZHFVImageUploader shareInstance]setUp];

}


#pragma mark - 登录
- (void)loginWithData:(NSData *)imageData{
    [self showIndicatorView];
    DECLARE_WEAK_SELF;
    [ZHFVNetworkManager requestUserVerifactionWithUploadData:imageData progress:nil
                                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"%@",responseObject);
         [weakSelf dismissIndicatorView];
         if ([[responseObject objectForKey:@"status"] boolValue] == 1) {
             if ([[responseObject objectForKey:@"extend"]boolValue]==1) {
                 [weakSelf loginWithDictionary:[responseObject objectForKey:@"data"]];
             }else{
                 NSString *error = [responseObject objectForKey:@"failureMsg"];
                 [weakSelf callBackLoginResult:nil error:[NSError errorWithDomain:error code:-1 userInfo:nil]];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         [weakSelf dismissIndicatorView];;
         [weakSelf callBackLoginResult:nil error:error];
     }];
}

///处理登录成功之后的结果
- (void)loginWithDictionary:(NSDictionary *)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.loginUser = [ZHFVUserModel modelWithDic:dic];
    if([[dic objectForKey:@"authorizationReminder"]integerValue]==1){
        //TODO:弹窗是否授权
        DECLARE_WEAK_SELF;
        ZHFVFinishRegistAlertView *view = [ZHFVFinishRegistAlertView alertWithInfomation:dic cancleAction:^{
            [weakSelf callBackLoginResult:nil error:[NSError errorWithDomain:@"用户取消授权" code:-1 userInfo:nil]];
        } confirmAction:^{
            [weakSelf callBackLoginResult:self.loginUser error:nil];
        }];
        [view show];
    }else{
        [self callBackLoginResult:self.loginUser error:nil];
    }
}

- (void)callBackLoginResult:(ZHFVUserModel *)model error:(NSError *)error{
    if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(userLoginComplete:error:)]) {
        [self.loginDelegate userLoginComplete:model error:error];
    }
    self.loginDelegate = nil;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"授权"]) {
        [self callBackLoginResult:self.loginUser error:nil];
    }
}



///注册流程
+ (UIViewController *)faceVerificatorWithRegistStepsWithDelegate:(id <ZHFVLoginDelegate>)delegate{
    return [[ZHFVManager shareInstance]faceVerificatorWithRegistStepsWithDelegate:delegate];

}
- (UIViewController *)faceVerificatorWithRegistStepsWithDelegate:(id <ZHFVLoginDelegate>)delegate{
    self.loginDelegate = delegate;
    ZHFVEntryViewController *viewController = [[ZHFVEntryViewController alloc]init];
    return viewController;
}



#pragma mark - 验证流程
///单步人脸验证
+ (UIViewController *)easyFaceVerificatorForUser:(ZHFVUserModel *)user delegate:(id <ZHFVVerifyDelegate>)delegate{
    return [[ZHFVManager shareInstance]easyFaceVerificatorForUser:user delegate:delegate];
}
///四步人脸验证
+ (UIViewController *)hardFaceVerificatorForUser:(ZHFVUserModel *)user delegate:(id <ZHFVVerifyDelegate>)delegate{
    return [[ZHFVManager shareInstance]hardFaceVerificatorForUser:user delegate:delegate];
}
- (UIViewController *)easyFaceVerificatorForUser:(ZHFVUserModel *)user delegate:(id <ZHFVVerifyDelegate>)delegate{
    self.verifyUser = user;
    self.verifyDelegate = delegate;
    STLivenessController *vc = [[STLivenessController alloc]initWithApiKey:ZH_FV_API_KEY apiSecret:ZH_FV_API_SECRET setDelegate:self detectionSequence:@[@(STIDLiveness_BLINK)]];
    vc.title = @"人脸验证";
    vc.isVoicePrompt = YES;
    vc.eachStepTimeOut = 20;
    self.verifyVC = vc;
    return vc;
}

- (UIViewController *)hardFaceVerificatorForUser:(ZHFVUserModel *)user delegate:(id <ZHFVVerifyDelegate>)delegate
{
    self.verifyUser = user;
    self.verifyDelegate = delegate;
    STLivenessController *vc = [[STLivenessController alloc]initWithApiKey:ZH_FV_API_KEY
                                                                 apiSecret:ZH_FV_API_SECRET setDelegate:self detectionSequence:@[@(STIDLiveness_BLINK) ,@(STIDLiveness_MOUTH) ,@(STIDLiveness_NOD),@(STIDLiveness_YAW)]];
    vc.title = @"人脸验证";
    vc.isVoicePrompt = YES;
    vc.eachStepTimeOut = 20;
    self.verifyVC = vc;
    return vc;
}


- (void)verifyWithImage:(NSData *)imageData{
    DECLARE_WEAK_SELF;
    [self showIndicatorView];
    [ZHFVNetworkManager userFaceVerificationwWithToken:self.verifyUser.accessToken imageFile:imageData userAuthenticationOpenid:self.verifyUser.userAuthenticationOpenid progress:^(NSProgress * _Nonnull progress) {
        
    } ssuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf dismissIndicatorView];
        if (weakSelf.verifyDelegate && [weakSelf.verifyDelegate respondsToSelector:@selector(userFaceVerfifyComplete:error:)]) {
            [weakSelf.verifyDelegate userFaceVerfifyComplete:responseObject error:nil];
        }
        weakSelf.verifyDelegate = nil;
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf dismissIndicatorView];
        if (weakSelf.verifyDelegate && [weakSelf.verifyDelegate respondsToSelector:@selector(userFaceVerfifyComplete:error:)]) {
            [weakSelf.verifyDelegate userFaceVerfifyComplete:nil error:error];
        }
        weakSelf.verifyDelegate = nil;
    }];
}



#pragma mark - 转圈圈
- (void)showIndicatorView{
    [[[UIApplication sharedApplication].delegate window]addSubview:self.indicatorView];;
    [self.indicatorView addSubview:self.indicator];
    [self.indicator startAnimating];
}

- (void)dismissIndicatorView{
    [self.indicator stopAnimating];
    [self.indicatorView removeFromSuperview];
}

- (void)showError:(NSString *)error{
    [[[UIAlertView alloc]initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    
}

#pragma mark - 续签
+ (void)refreshToken:(NSString *)oldSession openID:(NSString *)openID complete:(void(^)(id responseObject))completeBlock
{
    [ZHFVNetworkManager refreshToken:oldSession openid:openID progress:nil ssuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if (completeBlock) {
            completeBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (completeBlock) {
            completeBlock(error);
        }
    }];
}

#pragma mark - 解析出人脸
/**
 *  活体检测成功回调
 *
 *  @param protobufId         回传加密后的二进制数据在公有云的id
 *  @param protobufData       回传加密后的二进制数据
 *  @param requestId          网络请求的id
 *  @param imageArr           根据指定输出方案回传 STImage 数组 , STImage属性见 STImage.h
 */
- (void)livenessDidSuccessfulGetProtobufId:(NSString *)protobufId
                              protobufData:(NSData *)protobufData
                                 requestId:(NSString *)requestId
                                    images:(NSArray *)imageArr
{
    NSLog(@"%@",protobufId);
    id st_image = imageArr.firstObject;
    UIImage *image = [st_image valueForKey:@"image"];
    NSData *data = UIImagePNGRepresentation(image);
    if (self.verifyDelegate) {
        [self verifyWithImage:data];
    }
}

- (void)livenessDidFailWithLivenessResult:(STIDLivenessResult)livenessResult
                                faceError:(STIDLivenessFaceError)faceError
                             protobufData:(NSData *)protobufData
                                requestId:(NSString *)requestId
                                   images:(NSArray *)imageArr
{
    if (self.verifyVC) {
        [self.verifyVC showError:@"识别失败，请重试"];
        [self.verifyVC.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - getter
-(UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AILScreenWidth, AILScreenHeight)];
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AILScreenWidth, AILScreenHeight)];
        bgview.userInteractionEnabled = YES;
        bgview.backgroundColor = UIColorFromRGBA(0xffffff,0.7);
        [_indicatorView addSubview:bgview];
    }
    return _indicatorView;
}

-(UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [UIActivityIndicatorView new];
        _indicator.center = CGPointMake(AILScreenWidth/2, AILScreenHeight/2);
        _indicator.color = UIColorFromRGB(0x6396ea);
    }
    return _indicator;
}
@end
