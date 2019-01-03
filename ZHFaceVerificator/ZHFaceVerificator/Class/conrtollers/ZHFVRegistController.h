//
//  ZHFVRegistController.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/11/30.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AILBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZHFVRegistController : AILBaseViewController
///人脸识别的公有云ID
@property (nonatomic, strong)NSString *fvID;

@property (nonatomic, strong) UIImage *imageData;

@end

NS_ASSUME_NONNULL_END
