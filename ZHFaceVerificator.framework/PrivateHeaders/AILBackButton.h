//
//  AILBackButton.h
//  AILPublicLogic
//
//  Created by zhanghao on 2018/11/14.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AILBackButtonTapAction)(void);

@interface AILBackButton : UIView

+ (instancetype)button;

- (void)setTitle:(NSString *)title;

- (void)setTitleColor:(UIColor *)color;

- (void)setImage:(UIImage *)image;

- (void)setAction:(AILBackButtonTapAction)tapAction;

@end

NS_ASSUME_NONNULL_END
