//
//  ZHFVRegistController.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/11/30.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVRegistController.h"
#import "ZHFVNetworkManager.h"
#import "ZHFVUserInfoModel.h"
#import "STIdCardScanner.h"
#import "ZHFVIDCardController.h"
#import "HWTextCodeView.h"

@interface ZHFVRegistController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneTitleLabel;
@property (nonatomic, strong) UILabel *phonePrefixLabel;
@property (nonatomic, strong) UITextField *phoneNumTextFiled;
@property (nonatomic, strong) UIButton *nextStepButton;

@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UILabel *codeTitleLabel;
@property (nonatomic, strong) UILabel *codeTipsLabel;
@property (nonatomic, strong) HWTextCodeView *codeTextField;
@property (nonatomic, strong) UIButton *codeButton;



@property (nonatomic, strong) ZHFVUserInfoModel *userModel;
@end

@implementation ZHFVRegistController
{
    NSTimer *_countDownTimer;
    NSInteger _countDownTime;
}

#pragma mark - getter
-(UIView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, AILStatusBarHeight + AILNavigationBarHeight, AILScreenWidth, AILScreenHeight - AILStatusBarHeight  - AILNavigationBarHeight)];
        _phoneView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _phoneView;
}

-(UILabel *)phoneTitleLabel{
    if (!_phoneTitleLabel) {
        _phoneTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 84, 125, 32)];
        _phoneTitleLabel.font = [UIFont systemFontOfSize:30];
        _phoneTitleLabel.text = @"手机注册";
        _phoneTitleLabel.textColor = UIColorFromRGB(0x6396ea);
    }
    return _phoneTitleLabel;
}

-(UILabel *)phonePrefixLabel{
    if (!_phonePrefixLabel) {
        _phonePrefixLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, self.phoneTitleLabel.stBottom+160, 40, 44)];
        _phonePrefixLabel.font = [UIFont systemFontOfSize:16];
        _phonePrefixLabel.text = @"+86";
        _phonePrefixLabel.textColor = UIColorFromRGB(0x333333);
        
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(_phonePrefixLabel.stWidth-0.5, 5, 0.4, 34)];
        sepLine.backgroundColor = UIColorFromRGB(0xcccccc);
        [_phonePrefixLabel addSubview:sepLine];
    }
    return _phonePrefixLabel;
}

-(UITextField *)phoneNumTextFiled{
    if (!_phoneNumTextFiled) {
        _phoneNumTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(self.phonePrefixLabel.stRight+12, self.phonePrefixLabel.stTop, AILScreenWidth - self.phonePrefixLabel.stRight - 12, self.phonePrefixLabel.stHeight)];
        _phoneNumTextFiled.borderStyle = UITextBorderStyleNone;
        _phoneNumTextFiled.delegate = self;
        _phoneNumTextFiled.placeholder = @"手机号";
        _phoneNumTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextFiled.textColor = UIColorFromRGB(0x333333);
        _phoneNumTextFiled.returnKeyType = UIReturnKeyDone;
    }
    return _phoneNumTextFiled;
}

-(UIButton *)nextStepButton{
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.backgroundColor = UIColorFromRGB(0x6396ea);
        _nextStepButton.frame = CGRectMake(30, self.phoneNumTextFiled.stBottom+50, AILScreenWidth-60, 48);
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        _nextStepButton.layer.cornerRadius = 6;
        _nextStepButton.layer.masksToBounds = YES;
    }
    return _nextStepButton;
}

-(UIView *)codeView{
    if (!_codeView) {
        _codeView = [[UIView alloc]initWithFrame:CGRectMake(AILScreenWidth, AILStatusBarHeight + AILNavigationBarHeight, AILScreenWidth, AILScreenHeight - AILStatusBarHeight  - AILNavigationBarHeight)];
        _codeView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _codeView;
}

-(UILabel *)codeTitleLabel{
    if (!_codeTitleLabel) {
        _codeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 160, 32)];
        _codeTitleLabel.font = [UIFont systemFontOfSize:30];
        _codeTitleLabel.text = @"短信验证码";
        _codeTitleLabel.textColor = UIColorFromRGB(0x6396ea);
    }
    return _codeTitleLabel;
}

-(UILabel *)codeTipsLabel{
    if (!_codeTipsLabel) {
        _codeTipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, self.codeTitleLabel.stBottom + 8, 88, 32)];
        _codeTipsLabel.font = [UIFont systemFontOfSize:13];
        _codeTipsLabel.text = @"验证码已发送";
        _codeTipsLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _codeTipsLabel;
}

-(HWTextCodeView *)codeTextField{
    if (!_codeTextField) {
        DECLARE_WEAK_SELF;
        _codeTextField = [[HWTextCodeView alloc]initWithCount:6 margin:10 completeBlock:^(NSString * _Nonnull text) {
            [weakSelf goRegist];
        }];
        _codeTextField.frame = CGRectMake(30, self.codeTipsLabel.stBottom+60, AILScreenWidth - 60, 48);
    }
    return _codeTextField;
}

-(UIButton *)codeButton{
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.backgroundColor = [UIColor clearColor];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _codeButton.frame = CGRectMake(30, self.codeTextField.stBottom+20, 120, 28);
        _codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_codeButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机号注册";
    [self addSubViews];
}

- (void)addSubViews{
    [self.view addSubview:self.phoneView];
    [self.phoneView addSubview:self.phoneTitleLabel];
    [self.phoneView addSubview:self.phonePrefixLabel];
    [self.phoneView addSubview:self.phoneNumTextFiled];
    [self.phoneView addSubview:self.nextStepButton];
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(30, self.phoneNumTextFiled.stBottom, AILScreenWidth - 60, 0.5)];
    sep.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.phoneView addSubview:sep];
    
    [self.view addSubview:self.codeView];
    [self.codeView addSubview:self.codeTitleLabel];
    [self.codeView addSubview:self.codeTipsLabel];
    [self.codeView addSubview:self.codeTextField];
    [self.codeView addSubview:self.codeButton];
}


#pragma mark - 显示输入验证码的view
- (void)showCodeView{
    [self.codeView.layer removeAllAnimations];
    [self.view bringSubviewToFront:self.codeView];
    [UIView animateWithDuration:0.3 animations:^{
        self.codeView.stLeft = 0;
    }completion:^(BOOL finished) {
        [self.codeTextField startEdite];
    }];
}

#pragma mark - 获取验证码
- (void)nextStep:(UIButton *)sender{
    DECLARE_WEAK_SELF;
    [ZHFVNetworkManager requestGetCodeForPhone:self.phoneNumTextFiled.text progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]boolValue]==1) {
            weakSelf.codeButton.enabled = NO;
            [weakSelf showCodeView];
            [weakSelf startCountDown];
            [weakSelf.codeTextField becomeFirstResponder];
        }
        else{
            [weakSelf showError:@"验证码发送失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [weakSelf showError:error.domain];
    }];
}
- (void)getCode:(UIButton *)sender{
    DECLARE_WEAK_SELF;
    [ZHFVNetworkManager requestGetCodeForPhone:self.phoneNumTextFiled.text progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"]boolValue]==1) {
            weakSelf.codeButton.enabled = NO;
            [weakSelf startCountDown];
            [weakSelf.codeTextField becomeFirstResponder];
        }
        else{
            [weakSelf showError:@"验证码发送失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [weakSelf showError:error.domain];
    }];
}

- (void)startCountDown{
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
    _countDownTime = 60;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat) userInfo:nil repeats:YES];
}

- (void)repeat{
    if (_countDownTime <=0) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"点击发送验证码" forState:UIControlStateNormal];
        return;
    }
    _countDownTime--;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒后可重新发送",(long)_countDownTime] forState:UIControlStateNormal];
}


#pragma mark - 注册
-(void)goRegist{
    
    DECLARE_WEAK_SELF;
    [self showIndicatorView];
    [ZHFVNetworkManager requestRegistForPhone:self.phoneNumTextFiled.text code:self.codeTextField.code progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        [weakSelf dismissIndicatorView];
        if ([[responseObject objectForKey:@"status"] boolValue]==1) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            ZHFVUserInfoModel *model = [ZHFVUserInfoModel modelWithDictionary:dic];
            model.identity = [responseObject objectForKey:@"extend"];
            weakSelf.userModel = model;
            [weakSelf startReadIDCard];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [weakSelf dismissIndicatorView];
    }];
}

#pragma mark - 开始上传身份证信息
- (void)startReadIDCard{
    ZHFVIDCardController *controller = [[ZHFVIDCardController alloc]init];
    controller.userModel = self.userModel;
    controller.fvID = self.fvID;
    controller.imageData = self.imageData;
    [self.navigationController pushViewController:controller animated:YES];
}



#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.phoneNumTextFiled) {
        [self.view endEditing:YES];
        [self nextStep:self.nextStepButton];
    }
    return NO;
}



@end
