//
//  STIDCardView.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/15.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCardScanView.h"

@interface STIdCardView : STCardScanView

- (instancetype)initWithFrame:(CGRect)frame
                  windowFrame:(CGRect)windowFrame
                  orientation:(UIInterfaceOrientation)orientation;

- (void)moveWindowDeltaY:(NSInteger)iDeltaY;

- (void)setLabel:(UILabel *)label;

@end
