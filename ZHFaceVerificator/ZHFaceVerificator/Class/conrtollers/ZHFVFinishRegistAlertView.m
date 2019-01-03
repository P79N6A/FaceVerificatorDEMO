//
//  ZHFVFinishRegistAlertView.m
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/11.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "ZHFVFinishRegistAlertView.h"
#import "ZHFVConst.h"
#import "UIView+STLayout.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@interface ZHFVFinishRegistAlertView()

@property (nonatomic, strong) UIView *bgview;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UIImageView *logoView;

@property (nonatomic, strong) UILabel *tipsLable;

@property (nonatomic, strong) UILabel *rightsLable;

@property (nonatomic, strong) UIButton *refuseButton;

@property (nonatomic, strong) UIButton *allowButton;

@property (nonatomic, strong) UIView *sep1;
@property (nonatomic, strong) UIView *sep2;
@property (nonatomic, strong) UIView *sep3;

@property (nonatomic, strong) NSDictionary *info;

@property (nonatomic, copy) void(^refuseBlock)(void);

@property (nonatomic, copy) void(^confirmBlcok)(void);


@end

@implementation ZHFVFinishRegistAlertView
+ (instancetype)alertWithInfomation:(NSDictionary *)info cancleAction:(void(^)(void))cancleBlock confirmAction:(void(^)(void))confirmBlock{
    ZHFVFinishRegistAlertView *view = [[ZHFVFinishRegistAlertView alloc]initWithFrame: [UIScreen mainScreen].bounds];
    view.info = info;
    view.refuseBlock = cancleBlock;
    view.confirmBlcok = confirmBlock;
    [view buildSubviews];
    [view downloadImage];
    return view;
}

- (void)downloadImage{
    NSString *url = [self.info objectForKey:@"appHeadPortrait"];
    [self.logoView setImageWithURL:[NSURL URLWithString:url]];
}

- (void)buildSubviews{
    [self addSubview:self.bgview];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoView];
    [self.infoView addSubview:self.sep1];
    [self.infoView addSubview:self.logoView];
    [self.infoView addSubview:self.tipsLable];
    [self.infoView addSubview:self.sep2];
    [self.infoView addSubview:self.rightsLable];
    [self.infoView addSubview:self.sep3];
    [self.contentView addSubview:self.refuseButton];
    [self.contentView addSubview:self.allowButton];
    UIView *sep4 = [[UIView alloc]initWithFrame:CGRectMake(self.refuseButton.stRight, self.refuseButton.stTop, 0.5, self.refuseButton.stHeight)];
    sep4.backgroundColor = self.sep3.backgroundColor;
    [self.contentView addSubview:sep4];
}

- (void)show{
    self.alpha = 0;
    [[[UIApplication sharedApplication].delegate window]addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - getter
-(UIView *)bgview{
    if (!_bgview) {
        _bgview = [[UIView alloc]initWithFrame:self.bounds];
        _bgview.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
    }
    return _bgview;
}

-(UIView *)contentView{
    if (!_contentView) {
        CGFloat width = AILScreenWidth-90;
        CGFloat height = 260;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(45, (AILScreenHeight-height)/2, width, height)];
        _contentView.backgroundColor = UIColorFromRGB(0xffffff);
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.stWidth, 45)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = UIColorFromRGB(0x111111);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"人脉团授权";
    }
    return _titleLabel;
}

-(UIView *)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.titleLabel.stBottom, self.contentView.stWidth, self.contentView.stHeight-90)];
        _infoView.backgroundColor =UIColorFromRGB(0xffffff);
    }
    return _infoView;
}

-(UIView *)sep1{
    if (!_sep1) {
        _sep1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.infoView.stWidth, 0.5)];
        _sep1.backgroundColor = UIColorFromRGB(0xd0d0d0);
    }
    return _sep1;
}

-(UIImageView *)logoView{
    if (!_logoView) {
        _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 60, 60)];
        _logoView.layer.cornerRadius = 30;
        _logoView.layer.masksToBounds = YES;
        _logoView.backgroundColor = UIColorFromRGB(0xe8283e);
        _logoView.stCenterX = self.infoView.stWidth/2;
    }
    return _logoView;
}

-(UILabel *)tipsLable{
    if (!_tipsLable) {
        _tipsLable = [[UILabel alloc]initWithFrame:CGRectMake(30, self.logoView.stBottom+16, self.infoView.stWidth-60, 20)];
        _tipsLable.font = [UIFont boldSystemFontOfSize:15];
        _tipsLable.textColor = UIColorFromRGB(0x111111);
        _tipsLable.textAlignment = NSTextAlignmentLeft;
        _tipsLable.text = [NSString stringWithFormat:@"%@申请获得以下权限",[self.info objectForKey:@"appName"]];
    }
    return _tipsLable;
}

-(UIView *)sep2{
    if (!_sep2) {
        _sep2 = [[UIView alloc]initWithFrame:CGRectMake(30, self.tipsLable.stBottom+6, self.infoView.stWidth-60, 0.5)];
        _sep2.backgroundColor = UIColorFromRGB(0xd0d0d0);
    }
    return _sep2;
}

-(UILabel *)rightsLable{
    if (!_rightsLable) {
        _rightsLable = [[UILabel alloc]initWithFrame:CGRectMake(30, self.sep2.stBottom+6, self.infoView.stWidth-60, 20)];
        _rightsLable.font = [UIFont systemFontOfSize:14.0];
        _rightsLable.textColor = UIColorFromRGB(0x333333);
        _rightsLable.textAlignment = NSTextAlignmentLeft;
        _rightsLable.text = @"·获取您的公开信息(昵称、头像等)";
    }
    return _rightsLable;
}

-(UIView *)sep3{
    if (!_sep3) {
        _sep3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoView.stHeight-0.5, self.infoView.stWidth, 0.5)];
        _sep3.backgroundColor = UIColorFromRGB(0xd0d0d0);
    }
    return _sep3;
}

-(UIButton *)refuseButton{
    if (!_refuseButton) {
        _refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _refuseButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _refuseButton.frame = CGRectMake(0, self.infoView.stBottom, self.contentView.stWidth/2, 45);
        [_refuseButton addTarget:self action:@selector(refuse:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseButton;
}

-(UIButton *)allowButton{
    if (!_allowButton) {
        _allowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allowButton setTitle:@"授权" forState:UIControlStateNormal];
        [_allowButton setTitleColor:UIColorFromRGB(0x62b900) forState:UIControlStateNormal];
        _allowButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _allowButton.frame = CGRectMake(self.contentView.stWidth/2, self.infoView.stBottom, self.contentView.stWidth/2, 45);
        [_allowButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allowButton;
}
- (void)refuse:(UIButton *)sender{
    if (self.refuseBlock) {
        self.refuseBlock();
    }
    [self dismiss];
}

- (void)confirm:(UIButton *)sender{
    if (self.confirmBlcok) {
        self.confirmBlcok();
    }
    [self dismiss];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
