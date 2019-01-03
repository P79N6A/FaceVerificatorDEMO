//
//  AILBaseViewController.m
//  AILPublicLogic
//
//  Created by zhanghao on 2018/7/10.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "AILBaseViewController.h"
#import "ZHFVConst.h"
@interface AILBaseViewController ()

@property (nonatomic, strong) UIView *userInteracationView;
@property (nonatomic, strong)UIView *indicatorView;

@property (nonatomic, strong)UIActivityIndicatorView *indicator;

@end

@implementation AILBaseViewController
- (void)showIndicatorView{
    [[[UIApplication sharedApplication].delegate window]addSubview:self.indicatorView];;
    [self.indicatorView addSubview:self.indicator];
    [self.indicator startAnimating];
}

- (void)dismissIndicatorView{
    [self.indicator stopAnimating];
    [self.indicatorView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if ([self showBackButton]) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self showBackButtonTittle]) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index-1<self.navigationController.viewControllers.count && index-1>=0) {
            UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:index-1];
            NSString *title = vc.title?vc.title:@"返回";
            if (title.length>4) {
                title = @"返回";
            }
            [self.backButton setTitle:title];
        }
    }else{
        [self.backButton setTitle:@"   "];
    }
}


#pragma mark - setter  getter
-(AILNavigationStyle)preferredNavigationStyle{
    
    return AILNavigationStyleLightStyle;
    
}

-(AILBackButton *)backButton{
    if (!_backButton) {
        _backButton = [AILBackButton button];
        DECLARE_WEAK_SELF;
        [_backButton setAction:^{
            [weakSelf naviGoBack];
        }];
    }
    return _backButton;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    AILNavigationStyle style = [self preferredNavigationStyle];
    
    switch (style) {
        case AILNavigationStyleLightStyle:
        {
            [self.backButton setImage:[UIImage imageNamed:@"icon_back"]];
            [self.backButton setTitleColor:UIColorFromRGB(0x333333)];
            self.navigationController.navigationBar.barTintColor = nil;
            self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
            return UIStatusBarStyleDefault;
        }
        case AILNavigationStyleDarkStyle:
        {
            [self.backButton setImage:[UIImage imageNamed:@"icon_back_white"]];
            [self.backButton setTitleColor:UIColorFromRGB(0xffffff)];
            self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
            return UIStatusBarStyleLightContent;
        }
    }
}

- (void)showError:(NSString *)error{
    [[[UIAlertView alloc]initWithTitle:nil message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    
}

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

-(UIView *)userInteracationView{
    if (!_userInteracationView) {
        _userInteracationView = [[UIView alloc]init];
        _userInteracationView.userInteractionEnabled = YES;
        _userInteracationView.backgroundColor = UIColorFromRGBA(0xffffff,0.2);
        _userInteracationView.frame = CGRectMake(0, AILStatusBarHeight+AILNavigationBarHeight, AILScreenWidth, AILScreenHeight - (AILStatusBarHeight+AILNavigationBarHeight));
    }
    return _userInteracationView;
}

- (void)naviGoBack{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)disableUserInteraction{
    [self.view addSubview:self.userInteracationView];
    [self.view bringSubviewToFront:self.userInteracationView];
}

- (void)enableUserInteraction{
    [self.userInteracationView removeFromSuperview];
}


- (BOOL)showBackButtonTittle{
    return YES;
}

- (BOOL)showBackButton{
    return YES;
}


@end
