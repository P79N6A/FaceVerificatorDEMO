//
//  STLivenessCommon.h
//  STLivenessController
//
//  Created by sluin on 15/12/4.
//  Copyright © 2015年 SunLin. All rights reserved.
//

#ifndef STLivenessCommon_h
#define STLivenessCommon_h

//#error 请将账户信息补全，然后删除此行。Fill in your account info below, and delete this line.
#define ACCOUNT_API_KEY @"dafdd2de24d7428db1fad4132569ce52"
#define ACCOUNT_API_SECRET @"ac8eac24290d41809d4ff774f1ca2bbe"


#define kSTColorWithRGB(rgbValue)                                         \
    [UIColor colorWithRed:((float) ((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float) ((rgbValue & 0xFF00) >> 8)) / 255.0    \
                     blue:((float) (rgbValue & 0xFF)) / 255.0             \
                    alpha:1.0]

#define kSTScreenWidth [UIScreen mainScreen].bounds.size.width
#define kSTScreenHeight [UIScreen mainScreen].bounds.size.height

#define kSTViewTagBase 1000

#endif /* STLivenessCommon_h */
