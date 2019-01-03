//
//  ZHFVIDCardController.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AILBaseViewController.h"
#import "ZHFVUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZHFVIDCardController : AILBaseViewController


@property (nonatomic, strong)ZHFVUserInfoModel *userModel;

@property (nonatomic, strong) UIImage *imageData;
///人脸识别的公有云ID
@property (nonatomic, strong)NSString *fvID;
@end

NS_ASSUME_NONNULL_END
