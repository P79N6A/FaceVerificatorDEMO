//
//  testVCViewController.m
//  FaceVerificatorDEMO
//
//  Created by zhanghao on 2018/12/2.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "testVCViewController.h"
#import <MJExtension/MJExtension.h>
#import "NSObject+JsonHelper.h"

@interface testVCViewController ()<UIActionSheetDelegate,ZHFVLoginDelegate,ZHFVVerifyDelegate>

@property (nonatomic, strong)UIButton *registButton;

@property (nonatomic, strong) UILabel *loginStatues;

@property (nonatomic, strong)UIButton *testButton;

@property (nonatomic, strong)ZHFVUserModel *userModel;

@end

@implementation testVCViewController

// MARK: - lifeCircle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]) {
        self.userModel = [ZHFVUserModel modelWithDic:[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]];
        //    [ZHFVManager setUpWithAppkey:@"APPKEY10000000001" appSecret:@"APPSECRET10000000001"];
        NSDictionary *params =@{
                                @"accessToken":self.userModel.accessToken,
                                @"appKey":@"APPKEY10000000001",
                                @"appSecret":@"APPSECRET10000000001"
                                };
        [[AFHTTPSessionManager manager] POST:@"http://api.face.renmaituan.com/developer/api/app-user-authentication/user-extra-base-info"
                                 parameters:params
                                   progress:nil
                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        NSLog(@"repsonseObject = %@",responseObject);
                                        self->_loginStatues.text = [NSString stringWithFormat:@"name = %@\n tel = %@",self.userModel.userNickname,responseObject[@"data"][@"mobileNumber"]];
                                        
                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                        
                                    }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.registButton];
    [self.view addSubview:self.testButton];
    [self.view addSubview:self.loginStatues];
}

// MARK: -  注册
- (void)regist:(UIButton *)sender{
    UIViewController *vc = [ZHFVManager faceVerificatorWithRegistStepsWithDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 测试
- (void)test:(UIButton *)sender{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择功能(需要先登录)" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"单步验证",@"四步验证",@"续签", nil];
    [act showInView:self.view];
}

// MARK: - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"取消"])
    {
        return;
    }
    if (!self.userModel) {
        [self showError:@"未登录过"];
        return;
    }
    if([title isEqualToString:@"单步验证"]){
        if (!self.userModel) {
            [self showError:@"未登录过"];
            return;
        }
        //登录验证
        UIViewController *controller = [ZHFVManager easyFaceVerificatorForUser:self.userModel delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([title isEqualToString:@"四步验证"]){
        UIViewController *controller = [ZHFVManager hardFaceVerificatorForUser:self.userModel delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([title isEqualToString:@"续签"]){
        DECLARE_WEAK_SELF;
        [ZHFVManager refreshToken:self.userModel.refreshToken
                           openID:self.userModel.userAuthenticationOpenid
                         complete:^(id  _Nonnull responseObject) {
            if([responseObject isKindOfClass:[NSDictionary class]]){
                NSString *obj = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil] encoding:NSUTF8StringEncoding];
                [weakSelf showError:obj];
            }
            if ([responseObject isKindOfClass: [NSError class]]) {
                [self showError:((NSError *)responseObject).domain];
            }
        }];
    }
}

// MARK: - ZHFVLoginDelegate
-(void)userLoginComplete:(ZHFVUserModel *)userInfo error:(nonnull NSError *)error{
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo jsonValue] forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToViewController:self animated:YES];
    if (error) {
        [self showError:error.domain];
    }else{
        self.userModel = userInfo;
        self.loginStatues.text = [NSString stringWithFormat:@"%@ 已登录",userInfo.userNickname];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

// MARK: - ZHFVVerifyDelegate
- (void)userFaceVerfifyComplete:(nonnull id)responseObj error:(nonnull NSError *)error{
    [self.navigationController popToViewController:self animated:YES];
    if (error) {
        [self showError:error.domain];
    }else{
        NSString *obj = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObj options:0 error:nil] encoding:NSUTF8StringEncoding];
        [self showError:obj];
    }
}

#pragma mark - getter
-(UIButton *)registButton{
    if (!_registButton) {
        _registButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registButton setTitle:@"登录/注册流程" forState:UIControlStateNormal];
        _registButton.backgroundColor = UIColorFromRGB(0x16aff0);
        _registButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 230)/2, 120, 230, 45);
        [_registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

-(UIButton *)testButton{
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"其他功能" forState:UIControlStateNormal];
        _testButton.backgroundColor = UIColorFromRGB(0x6396ea);
        _testButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 230)/2, 280, 230, 45);
        [_testButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

-(UILabel *)loginStatues{
    if (!_loginStatues) {
        _loginStatues = [[UILabel alloc]initWithFrame:CGRectMake(0, 480, [UIScreen mainScreen].bounds.size.width, 80)];
        _loginStatues.textAlignment = NSTextAlignmentCenter;
        _loginStatues.numberOfLines = 0;
        _loginStatues.font = [UIFont systemFontOfSize:18.0];
        _loginStatues.textColor = UIColorFromRGB(0x333333);
        _loginStatues.text = @"未登录";
    }
    return _loginStatues;
}



-(BOOL)showBackButton{
    return NO;
}
@end
