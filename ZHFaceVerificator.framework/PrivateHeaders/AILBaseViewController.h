//
//  AILBaseViewController.h
//  AILPublicLogic
//
//  Created by zhanghao on 2018/7/10.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AILBackButton.h"
#import "UIView+STLayout.h"
#import "ZHFVConst.h"
typedef enum {
    AILNavigationStyleLightStyle,//白色
    AILNavigationStyleDarkStyle,//黑色
}AILNavigationStyle;

@interface AILBaseViewController : UIViewController

@property (nonatomic, strong) AILBackButton *backButton;

- (AILNavigationStyle)preferredNavigationStyle;

- (void)naviGoBack;

- (void)disableUserInteraction;

- (void)enableUserInteraction;

- (BOOL)showBackButtonTittle;

- (BOOL)showBackButton;

- (void)showIndicatorView;

- (void)dismissIndicatorView;

- (void)showError:(NSString *)error;
@end
