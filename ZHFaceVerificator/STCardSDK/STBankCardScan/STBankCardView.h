//
//  STBankCardView.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/3/6.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCardScanView.h"

@interface STBankCardView : STCardScanView

- (void)changeScanWindowDirection:(BOOL)isVertical;

- (instancetype)initWithFrame:(CGRect)frame
                  windowFrame:(CGRect)windowFrame
                  orientation:(UIInterfaceOrientation)orientation;

- (void)moveWindowDeltaY:(NSInteger)iDeltaY;

@end
