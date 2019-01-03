//
//  ZHFVFinishRegistAlertView.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/11.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHFVFinishRegistAlertView : UIView



+ (instancetype)alertWithInfomation:(NSDictionary *)info cancleAction:(void(^)(void))cancleBlock confirmAction:(void(^)(void))confirmBlock;

- (void)show;


@end

NS_ASSUME_NONNULL_END
