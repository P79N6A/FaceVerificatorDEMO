//
//  ZHFVEntryViewController.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/11/30.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AILBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHFVEntryViewController : AILBaseViewController
///是否需要语音提示
@property (nonatomic, assign)BOOL voiceVisible;
///每一步的超时时间
@property (nonatomic, assign)NSInteger eachStepTimeOut;

@end

NS_ASSUME_NONNULL_END
