//
//  STBankCardView.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/6.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STBankCardView.h"
#import "STDefineHeader.h"

NSInteger const STBankCardViewLabelFrontSize = 15;
NSInteger const STBankCardViewFrameShrinkSize = 12;

@interface STBankCardView ()

@property (nonatomic, strong) UILabel *labelScan;
//@property(nonatomic, strong) CALayer *layerLine;
@property (nonatomic, assign) CGRect moveCardWindow;
@property (nonatomic, strong) CALayer *upLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) CALayer *rightLine;
@property (nonatomic, strong) CALayer *leftLine;

@end

@implementation STBankCardView

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
    [_labelScan setFont:[UIFont systemFontOfSize:STBankCardViewLabelFrontSize]];
    [_labelScan setFrame:CGRectMake(0,
                                    0,
                                    SCREEN_WIDTH,
                                    30)]; // CGRectMake(0.0f, 80.0f, SCREEN_WIDTH, SCREEN_HEIGHT- rectFrame.origin.y)];
    if (orientation == UIInterfaceOrientationPortrait) {
        _labelScan.center = CGPointMake(CGRectGetMidX(self.windowFrame),
                                        CGRectGetMinY(self.windowFrame) - CGRectGetHeight(self.windowFrame) / 6);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        _labelScan.center = CGPointMake(CGRectGetMaxX(self.windowFrame) + CGRectGetWidth(self.windowFrame) / 10,
                                        CGRectGetMidY(self.windowFrame));
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
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
    _labelScan.text = @"请将银行卡放入扫描框内";
    _labelScan.numberOfLines = 2;
    _moveCardWindow = CGRectZero;
    [self addSubview:_labelScan];
    return self;
}
- (void)changeScanWindowDirection:(BOOL)isVertical {
    CGRect videoWindow;
    if (isVertical) {
        videoWindow = MASK_WINDOW_VERTICALCARD;
    } else {
        videoWindow = MASK_WINDOW_H;
    }

    if (isVertical && !(self.orientation == UIInterfaceOrientationPortrait)) {
        self.labelScan.transform = CGAffineTransformMakeRotation(-M_PI * 2);
    }

    NSInteger fitIPhone4Ratio = 0;
    if (SCREEN_HEIGHT == 480) {
        fitIPhone4Ratio = 20; // fit iPhone ratio
    }
    self.windowFrame = CGRectMake(videoWindow.origin.x / VIEDO_WIDTH * SCREEN_WIDTH,
                                  videoWindow.origin.y / VIDEO_HEIGHT * SCREEN_HEIGHT - fitIPhone4Ratio,
                                  videoWindow.size.width / VIEDO_WIDTH * SCREEN_WIDTH,
                                  videoWindow.size.height / VIDEO_HEIGHT * SCREEN_HEIGHT + fitIPhone4Ratio * 2);

    if (!isVertical && _moveCardWindow.size.width) {
        self.windowFrame = _moveCardWindow;
    }
    if (isVertical) {
        // shrink the scan frame size
        self.windowFrame = CGRectMake(self.windowFrame.origin.x + STBankCardViewFrameShrinkSize,
                                      self.windowFrame.origin.y + STBankCardViewFrameShrinkSize * 2,
                                      self.windowFrame.size.width - STBankCardViewFrameShrinkSize * 2,
                                      self.windowFrame.size.height - STBankCardViewFrameShrinkSize * 4);
    }
    [self setNeedsDisplay];
    _labelScan.center = CGPointMake(CGRectGetMidX(self.windowFrame),
                                    CGRectGetMinY(self.windowFrame) - CGRectGetHeight(self.windowFrame) / 10);
}

- (void)moveWindowDeltaY:(NSInteger)iDeltaY {
    CGRect rectFrame = self.windowFrame;
    if (rectFrame.size.height < rectFrame.size.width) {
        rectFrame.origin.y += (CGFloat) iDeltaY;
    }
    self.windowFrame = rectFrame;
    self.moveCardWindow = rectFrame;

    if (self.orientation == UIInterfaceOrientationPortrait) {
        _labelScan.center = CGPointMake(CGRectGetMidX(self.windowFrame),
                                        CGRectGetMinY(self.windowFrame) - CGRectGetHeight(self.windowFrame) / 6);
    }

    [self setNeedsDisplay];
}

@end
