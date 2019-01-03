//
//  STVideoCaptureView.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/9.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCardScanMaskView : UIView

@property (nonatomic, assign) CGRect windowRect;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) CGFloat maskAlpha;

@end

@protocol STCardScanViewDelegate <NSObject>
- (void)didCancel;
@end

@interface STCardScanView : UIView

@property (nonatomic, weak) id<STCardScanViewDelegate> cardScanViewDelegate;
@property (nonatomic, assign) CGRect windowFrame;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) CGAffineTransform interfaceTransform;
@property (nonatomic, strong) STCardScanMaskView *maskCoverView;

- (instancetype)initWithFrame:(CGRect)frame
                  windowFrame:(CGRect)windowFrame
                  orientation:(UIInterfaceOrientation)orientation;

@end
