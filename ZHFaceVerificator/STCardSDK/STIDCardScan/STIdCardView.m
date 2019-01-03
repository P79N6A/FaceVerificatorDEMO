//
//  STIdCardView.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/15.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STIdCardView.h"
#import "STDefineHeader.h"

NSInteger const STIdCardViewLabelFrontSize = 15;

@interface STIdCardView ()

@property (nonatomic, strong) UILabel *labelScan;

@end

@implementation STIdCardView

- (instancetype)initWithFrame:(CGRect)frame
                  windowFrame:(CGRect)windowFrame
                  orientation:(UIInterfaceOrientation)orientation {
    self = [super initWithFrame:frame windowFrame:windowFrame orientation:orientation];
    if (!self) {
        return self;
    }
    _labelScan = [[UILabel alloc] init];
    [_labelScan setBackgroundColor:[UIColor clearColor]];
    [_labelScan setTextColor:[UIColor whiteColor]];
    [_labelScan setFont:[UIFont systemFontOfSize:STIdCardViewLabelFrontSize]];
    [_labelScan setFrame:CGRectMake(0,
                                    0,
                                    SCREEN_WIDTH,
                                    30)]; // CGRectMake(0.0f, 80.0f, SCREEN_WIdTH, SCREEN_HEIGHT- rectFrame.origin.y)];
    if (orientation == UIInterfaceOrientationPortrait) {
        _labelScan.center = CGPointMake(CGRectGetMidX(self.windowFrame),
                                        CGRectGetMinY(self.windowFrame) - CGRectGetHeight(self.windowFrame) / 6);
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        _labelScan.center = CGPointMake(CGRectGetWidth(self.windowFrame) / 10, CGRectGetMidY(self.windowFrame));
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        _labelScan.center = CGPointMake(CGRectGetMaxX(self.windowFrame) + CGRectGetWidth(self.windowFrame) / 10,
                                        CGRectGetMidY(self.windowFrame));
    }
    [_labelScan setTextAlignment:NSTextAlignmentCenter];
    [_labelScan setNumberOfLines:10];
    _labelScan.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.7].CGColor;
    _labelScan.layer.shadowOffset = CGSizeMake(7, 7);
    _labelScan.layer.shadowOpacity = 1.0;
    _labelScan.layer.shadowRadius = 5.0;
    _labelScan.transform = self.interfaceTransform;
    _labelScan.text = @"请将身份证放入扫描框内";
    _labelScan.numberOfLines = 2;
    [self addSubview:_labelScan];
    return self;
}

- (void)moveWindowDeltaY:(NSInteger)iDeltaY //  fDeltaY == 0 in center , < 0 move up, > 0 move down
{
    CGRect rectFrame = self.windowFrame;
    if (rectFrame.size.height < rectFrame.size.width) {
        rectFrame.origin.y += (CGFloat) iDeltaY;
    }
    self.windowFrame = rectFrame;
    _labelScan.center = CGPointMake(CGRectGetMidX(self.windowFrame),
                                    CGRectGetMinY(self.windowFrame) - CGRectGetHeight(self.windowFrame) / 6);
    [self setNeedsDisplay];
}

- (void)setLabel:(UILabel *)label {
    _labelScan.text = label.text;
    _labelScan.textColor = label.textColor;
    [_labelScan setNeedsDisplay];
}

@end
