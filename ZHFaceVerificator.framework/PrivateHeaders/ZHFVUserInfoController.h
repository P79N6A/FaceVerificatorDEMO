//
//  ZHFVUserInfoController.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/12/1.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AILBaseViewController.h"
#import "ZHFVUserInfoModel.h"
#import "STIdCardScanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHFVUserInfoController : AILBaseViewController
@property (nonatomic, strong)ZHFVUserInfoModel *userModel;

@property (nonatomic, strong)STIdCard *frontRes;
///人脸识别的公有云ID
@property (nonatomic, strong)NSString *fvID;
@property (nonatomic, strong) UIImage *imageData;

@end

NS_ASSUME_NONNULL_END
