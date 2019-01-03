//
//  AILBackButton.m
//  AILPublicLogic
//
//  Created by zhanghao on 2018/11/14.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import "AILBackButton.h"
#import "ZHFVConst.h"
#import "UIView+STLayout.h"
@interface AILBackButton()

@property (nonatomic, strong)UIImageView *backIcon;
@property (nonatomic, strong)UILabel *backTitle;
@property (nonatomic, copy)AILBackButtonTapAction action;

@end

@implementation AILBackButton

+ (instancetype)button{
    AILBackButton *button = [AILBackButton new];
    if (button) {
        [button addSubview:button.backIcon];
        [button addSubview:button.backTitle];
        button.frame = CGRectMake(0, 0, 80, 44);
        [button makeConstrains];
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:button action:@selector(tapAction:)]];
    }
    return button;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.action) {
        self.action();
    }
}


- (void)makeConstrains{
    [self.backIcon setStCenterY:self.stHeight/2];
    [self.backIcon setStLeft:0];
    [self.backTitle setStLeft:self.backIcon.stRight+8];
    CGSize titleSize = [self.backTitle sizeThatFits:CGSizeMake(120, 20)];
    [self.backTitle setStWidth:titleSize.width];
    [self.backTitle setStHeight:self.stHeight];
    [self.backTitle setStTop:0];
    [self setStWidth:self.backTitle.stRight];
}

- (void)setTitle:(NSString *)title{
    self.backTitle.text = title;
    [self makeConstrains];
}

- (void)setTitleColor:(UIColor *)color{
    self.backTitle.textColor = color;
}

- (void)setImage:(UIImage *)image{
    self.backIcon.image = image;
}

- (void)setAction:(AILBackButtonTapAction)tapAction{
    _action = tapAction;
}

#pragma mark - getter
-(UIImageView *)backIcon{
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[FrameworkBundle pathForResource:@"icon_back@2x" ofType:@"png"]]];
    }
    return _backIcon;
}

-(UILabel *)backTitle{
    if (!_backTitle) {
        _backTitle = [[UILabel alloc]init];
        _backTitle.textAlignment = NSTextAlignmentLeft;
        _backTitle.textColor = UIColorFromRGB(0x333333);
        _backTitle.text = @"返回";
        _backTitle.font = [UIFont systemFontOfSize:16.0];
    }
    return _backTitle;
}

@end
