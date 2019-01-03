//
//  STVideoCaptureManger.h
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/4.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "STScanEnumHeader.h"

@interface STVideoCaptureManger : NSObject

@property (nonatomic, strong) AVCaptureVideoDataOutput *captureVideoOutput;
@property (nonatomic, assign) AVCaptureVideoOrientation captureVideoOrientation;
@property (nonatomic, assign) BOOL isScanVerticalCard;
@property (nonatomic, strong) id cardRecognizer;
@property (nonatomic, assign) CGRect scanVideoWindowRect;
@property (nonatomic, assign) BOOL isVideoStreamEnable;
@property (nonatomic, assign) NSInteger videoWidth;
@property (nonatomic, assign) NSInteger videoHeight;
@property (nonatomic, assign) STIdCardScanSide cardScanSide;
@property (nonatomic, assign) STIdCardScanMode cardScanMode;
@property (nonatomic, assign) STIdCardItemOption scanIdCardItemOption;

- (void)setVideoOrientation:(AVCaptureVideoOrientation)orientation;
- (CGRect)getMaskFrame;

@end
