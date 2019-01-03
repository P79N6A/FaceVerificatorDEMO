//
//  ZHFVConst.h
//  ZHFaceVerificator
//
//  Created by zhanghao on 2018/11/30.
//  Copyright © 2018 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>




NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString * const ZH_FV_API_KEY;
FOUNDATION_EXPORT NSString * const ZH_FV_API_SECRET;



#define FrameworkPath  [[NSBundle mainBundle] pathForResource:@"ZHFaceVerificator" ofType:@"framework"]
#define FrameworkBundle  [NSBundle bundleWithPath:FrameworkPath]

#define st_liveness_resourcePath [FrameworkBundle pathForResource:@"st_liveness_resource" ofType:@"bundle"]
#define st_liveness_resourceBundle [NSBundle bundleWithPath:st_liveness_resourcePath]

#define OCR_SDK_ResourcePath [FrameworkBundle pathForResource:@"OCR_SDK_Resource" ofType:@"bundle"]
#define OCR_SDK_ResourceBundle [NSBundle bundleWithPath:OCR_SDK_ResourcePath]



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0  alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue)  [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float) ((rgbValue & 0x00FF00) >> 8))/255.0  blue:((float)(rgbValue & 0x0000FF))/255.0  alpha:alphaValue]


//是否是iPhone X
#define is_iPhoneX          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)||CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)) : NO)
//状态栏高度
#define StatusBarHeight     (is_iPhoneX ? 44.f : 20.f)
#define AILStatusBarHeight StatusBarHeight
// 导航高度
#define NavigationBarHeight 44.f
#define AILNavigationBarHeight NavigationBarHeight

// Tabbar高度.   49 + 34 = 83
#define TabbarHeight        (is_iPhoneX ? 83.f : 49.f)
#define AILTabbarHeight TabbarHeight
// Tabbar安全区域底部间隙
#define TabbarSafeBottomMargin  (is_iPhoneX ? 34.f : 0.f)
#define AILTabbarSafeBottomMargin TabbarSafeBottomMargin
// 状态栏和导航高度
#define StatusBarAndNavigationBarHeight  (is_iPhoneX ? 88.f : 64.f)
#define AILStatusBarAndNavigationBarHeight
// safeAre
#define ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
#define AILViewSafeAreInsets(view) ViewSafeAreInsets(view)



#define DECLARE_WEAK_SELF __typeof(&*self) __weak weakSelf = self
#define DECLARE_STRONG_SELF __typeof(&*self) __strong strongSelf = weakSelf
#define AILScreenWidth [UIScreen mainScreen].bounds.size.width
#define AILScreenHeight [UIScreen mainScreen].bounds.size.height
#define AILGetString(a) a?[NSString stringWithFormat:@"%@",a]:@""


@interface ZHFVConst : NSObject

@end

NS_ASSUME_NONNULL_END
