//
//  ZHFVEntryViewController.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/11/30.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVEntryViewController.h"
#import "STLivenessController.h"
#import "ZHFVConst.h"
#import "AILBaseNavigationViewController.h"
#import "ZHFVRegistController.h"
#import "ZHFVNetworkManager.h"
#import "ZHFVIDCardController.h"
#import "ZHFVImageUploader.h"
#import "ZHFVLocationManager.h"
#import "ZHFVManager.h"
#import "ZHFVUserInfoController.h"
#import "ZHFVFinishRegistAlertView.h"


@interface ZHFVEntryViewController ()<STLivenessDetectorDelegate,STLivenessControllerDelegate>

@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UILabel *bigTitle;
@property (nonatomic, strong)UILabel *smallTittle;
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation ZHFVEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷脸登录";
    [self makeConstrains];
}

- (UINavigationController *)controllerWithNavigation{
    AILBaseNavigationViewController *navi = [[AILBaseNavigationViewController alloc]initWithRootViewController:self];
    return navi;
}
///设置UI
- (void)makeConstrains{
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.bigTitle];
    [self.view addSubview:self.smallTittle];
    [self.view addSubview: self.imageView];
    self.bigTitle.frame = CGRectMake(0, AILNavigationBarHeight + StatusBarHeight + 25, AILScreenWidth, 42);
    self.smallTittle.frame = CGRectMake(0, self.bigTitle.stBottom+6, AILScreenWidth, 25);
    self.imageView.stSize = CGSizeMake(370, 320);
    self.imageView.stCenterX = self.view.stWidth/2;
    self.imageView.stCenterY = self.view.stHeight/2;
    self.startButton.frame = CGRectMake(0, 0, 315, 45);
    [self.startButton setStCenterX:self.view.stWidth/2];
    [self.startButton setStBottom:self.view.stHeight - 37];
}





-(void)naviGoBack{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



///开始验证
- (void)startFaceVerificate:(UIButton *)sender{
//    
//    NSDictionary *dic = @{@"appName":@"测试Demo",@"appHeadPortrait":@""};
//    
//    ZHFVFinishRegistAlertView *view = [ZHFVFinishRegistAlertView alertWithInfomation:dic cancleAction:^{
//        
//    } confirmAction:^{
//        
//    }];
//    [view show];
//    return;
    
    
    
    STLivenessController *controller = [[STLivenessController alloc]initWithApiKey:ZH_FV_API_KEY apiSecret:ZH_FV_API_SECRET setDelegate:self detectionSequence:[ZHFVEntryViewController detectionArray]];
    controller.title = @"识别";
    controller.isVoicePrompt = YES;
    controller.eachStepTimeOut = self.eachStepTimeOut;
    if (self.navigationController) {
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navi animated:YES completion:^{
            
        }];
    }
}


+ (NSArray *)detectionArray{
    return @[@(STIDLiveness_BLINK) ,@(STIDLiveness_MOUTH) ,@(STIDLiveness_NOD),@(STIDLiveness_YAW)];
}



#pragma mark - 活体检测结果

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
    [self showIndicatorView];
    id st_image = imageArr.firstObject;
    UIImage *image = [st_image valueForKey:@"image"];
    if (image) {
        NSData *imageData =UIImagePNGRepresentation(image);
        DECLARE_WEAK_SELF;
        [ZHFVNetworkManager requestUserVerifactionWithUploadData:imageData progress:nil
                                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
         {
             [weakSelf dismissIndicatorView];
             if([responseObject isKindOfClass: [NSDictionary class]]){
                 if ([[responseObject objectForKey:@"status"] boolValue] == 0) {
                     [weakSelf showError:[responseObject objectForKey:@"failureMsg"]];
                 }else
                 {
                     if ([[responseObject objectForKey:@"extend"]boolValue]==0) {
                         ///未注册
                         ZHFVRegistController *con = [[ZHFVRegistController alloc]init];
                         con.fvID = protobufId;
                         con.imageData = image;
                         [weakSelf.navigationController pushViewController:con animated:YES];
                     }else{
                         [[ZHFVManager shareInstance] performSelector:@selector(loginWithDictionary:) withObject:[responseObject objectForKey:@"data"]];
                     }
                 }
             }
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
        {
            [weakSelf dismissIndicatorView];
            [weakSelf showError:error.domain];
        }];
    }
}



/**
 *  活体检测失败回调
 *
 *  @param livenessResult    运行结果STIDLivenessResult
 *  @param faceError         活体检测失败类型
 *  @param protobufData      回传加密后的二进制数据
 *  @param requestId         网络请求的id
 *  @param imageArr          根据指定输出方案回传 STImage 数组 , STImage属性见 STImage.h
 */
- (void)livenessDidFailWithLivenessResult:(STIDLivenessResult)livenessResult
                                faceError:(STIDLivenessFaceError)faceError
                             protobufData:(NSData *)protobufData
                                requestId:(NSString *)requestId
                                   images:(NSArray *)imageArr
{
    [self showError:@"识别失败，请重试"];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 跳转注册


#pragma mark - getter
-(UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = UIColorFromRGB(0x6396ea);
        [_startButton setTitle:@"开始检测" forState:UIControlStateNormal];
        [_startButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _startButton.layer.cornerRadius = 4;
        _startButton.layer.masksToBounds = YES;
        [_startButton addTarget:self action:@selector(startFaceVerificate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

-(UILabel *)bigTitle{
    if (!_bigTitle) {
        _bigTitle = [[UILabel alloc]init];
        _bigTitle.textAlignment = NSTextAlignmentCenter;
        _bigTitle.font = [UIFont systemFontOfSize:30];
        _bigTitle.text = @"刷脸登录";
    }
    return _bigTitle;
}

-(UILabel *)smallTittle{
    if (!_smallTittle) {
        _smallTittle = [[UILabel alloc]init];
        _smallTittle.textAlignment = NSTextAlignmentCenter;
        _smallTittle.font = [UIFont systemFontOfSize:18];
        _smallTittle.text = @"更快更安全";
    }
    return _smallTittle;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageWithContentsOfFile:[FrameworkBundle pathForResource:@"face" ofType:@"png"]];
    }
    return _imageView;
}


#pragma mark - 设置
-(BOOL)showBackButton{
    return YES;
}
@end
