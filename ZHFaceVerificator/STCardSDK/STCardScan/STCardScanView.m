//
//  STVideoCaptureView.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/9.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCardScanView.h"
#import "ZHFVConst.h"

@interface STCardScanView ()

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation STCardScanView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
                  windowFrame:(CGRect)windowFrame
                  orientation:(UIInterfaceOrientation)orientation {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // important for rotate
        CGFloat newHeight = windowFrame.size.height * [self modifyYRatio];
        CGFloat newY = windowFrame.origin.y - (newHeight - windowFrame.size.height) / 2.0;
        _windowFrame = CGRectMake(windowFrame.origin.x, newY, windowFrame.size.width, newHeight);
        _orientation = orientation;
        switch (_orientation) {
            case UIInterfaceOrientationLandscapeLeft:
                _interfaceTransform = CGAffineTransformMakeRotation(M_PI_2 * 3);
                break;
            case UIInterfaceOrientationLandscapeRight:
                _interfaceTransform = CGAffineTransformMakeRotation(M_PI_2);
                break;
            case UIInterfaceOrientationPortrait:
                _interfaceTransform = CGAffineTransformMakeRotation(0);
                break;
            default:
                _interfaceTransform = CGAffineTransformMakeRotation(0);
                break;
        }
        _maskCoverView = [[STCardScanMaskView alloc] initWithFrame:self.bounds];
        _maskCoverView.windowRect = self.windowFrame;
        [self addSubview:_maskCoverView];
        [_maskCoverView addSubview:self.cancelButton];
    }

    return self;
}

- (CGFloat)modifyYRatio {
    CGFloat videoRatio = 720.0 / 1280.0;
    CGFloat uiRatio = CGRectGetWidth(self.bounds) / CGRectGetHeight(self.bounds);
    return uiRatio / videoRatio;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
    _maskCoverView.windowRect = self.windowFrame;
    [_maskCoverView setNeedsDisplay];
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (OCR_SDK_ResourceBundle) {
            NSBundle *resourceBundle = OCR_SDK_ResourceBundle;
            UIImage *imgBtn =
                [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"Image/scan_back" ofType:@"png"]];
            _cancelButton.frame = CGRectMake(22, 20, 40, 40);
            [_cancelButton setImage:imgBtn forState:UIControlStateNormal];
            [_cancelButton addTarget:self action:@selector(didCancel) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _cancelButton;
}

- (void)didCancel {
    if (self.cardScanViewDelegate && [self.cardScanViewDelegate respondsToSelector:@selector(didCancel)]) {
        [self.cardScanViewDelegate didCancel];
    }
}

@end

@interface STCardScanMaskView ()

@property (assign, nonatomic) CGContextRef context;

@end
@implementation STCardScanMaskView {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineColor = [UIColor whiteColor];
        _maskAlpha = 0.8;
        _maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.context = UIGraphicsGetCurrentContext();
    CGFloat redColor = 12;
    CGFloat blueColor = 12;
    CGFloat greenColor = 12;
    [self.maskColor getRed:&redColor green:&greenColor blue:&blueColor alpha:nil];

    UIColor *maskColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:self.maskAlpha];
    [maskColor setFill];
    CGContextFillRect(self.context, self.bounds);
    CGContextClearRect(self.context, self.windowRect);

    CGFloat fLineWidth = 2;
    CGFloat fLineLength = 40;

    CGContextMoveToPoint(self.context,
                         self.windowRect.origin.x - fLineWidth / 2,
                         self.windowRect.origin.y + fLineLength);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x - fLineWidth / 2,
                            self.windowRect.origin.y - fLineWidth / 2);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x + fLineLength,
                            self.windowRect.origin.y - fLineWidth / 2);

    CGContextMoveToPoint(self.context,
                         self.windowRect.origin.x + self.windowRect.size.width - fLineLength,
                         self.windowRect.origin.y - fLineWidth / 2);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x + self.windowRect.size.width + fLineWidth / 2,
                            self.windowRect.origin.y - fLineWidth / 2);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x + self.windowRect.size.width + fLineWidth / 2,
                            self.windowRect.origin.y + fLineLength);

    CGContextMoveToPoint(self.context,
                         self.windowRect.origin.x - fLineWidth / 2,
                         self.windowRect.origin.y + self.windowRect.size.height - fLineLength);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x - fLineWidth / 2,
                            self.windowRect.origin.y + self.windowRect.size.height + fLineWidth / 2);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x + fLineLength,
                            self.windowRect.origin.y + self.windowRect.size.height + fLineWidth / 2);

    CGContextMoveToPoint(self.context,
                         self.windowRect.origin.x + self.windowRect.size.width - fLineLength,
                         self.windowRect.origin.y + self.windowRect.size.height + fLineWidth / 2);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x + self.windowRect.size.width + fLineWidth / 2,
                            self.windowRect.origin.y + self.windowRect.size.height + fLineWidth / 2);
    CGContextAddLineToPoint(self.context,
                            self.windowRect.origin.x + self.windowRect.size.width + fLineWidth / 2,
                            self.windowRect.origin.y + self.windowRect.size.height - fLineLength);

    [self.lineColor set];
    CGContextSetLineWidth(self.context, fLineWidth);
    CGContextStrokePath(self.context);
}

@end
