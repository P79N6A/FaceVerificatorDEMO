//
//  STVideoCaptureManger.m
//  LibSTCardScan
//
//  Created by zhanghenan on 2017/2/4.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <libkern/OSAtomic.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <sys/utsname.h>
#import "STVideoCaptureManger.h"
#import "STBankCardRecognizer.h"
#import "STIdCardRecognizer.h"
#include "STDefineHeader.h"

@interface STVideoCaptureManger () <AVCaptureVideoDataOutputSampleBufferDelegate> {
    dispatch_queue_t queue;
    volatile uint32_t state;
    volatile int32_t channel;
    volatile int8_t m_iTakeSnapAndStop;
}

@end

@implementation STVideoCaptureManger

- (instancetype)init {
    self = [super init];
    if (self) {
        // create AVCaptureVideoDataOutput
        self.captureVideoOutput = [[AVCaptureVideoDataOutput alloc] init];
        self.captureVideoOutput.alwaysDiscardsLateVideoFrames = YES;
        self.captureVideoOutput.videoSettings =
            @{(id) kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
        // create GCD queue
        queue = dispatch_queue_create("SenseTimeOCRVideoQueue", NULL);
        [self.captureVideoOutput setSampleBufferDelegate:self queue:queue];
        self.isVideoStreamEnable = YES;
    }
    return self;
}

- (void)setVideoOrientation:(AVCaptureVideoOrientation)orientation {
    [[self.captureVideoOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:orientation];
    self.captureVideoOrientation = orientation;
    if (self.isScanVerticalCard) {
        self.captureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.scanVideoWindowRect = VIDEO_WINDOW_V;
        self.videoWidth = 720;
        self.videoHeight = 1280;

    } else if (orientation == AVCaptureVideoOrientationPortrait) {
        self.scanVideoWindowRect = VIDEO_WINDOW_H;
        self.videoWidth = 720;
        self.videoHeight = 1280;
    } else {
        self.scanVideoWindowRect = VIDEO_WINDOW_V;
        self.videoWidth = 1280;
        self.videoHeight = 720;
    }
}

- (CGRect)getMaskFrame {
    if (self.captureVideoOrientation == AVCaptureVideoOrientationPortrait) {
        return MASK_WINDOW_H;
    }
    return MASK_WINDOW_V;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput //! OCLint
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
           fromConnection:(AVCaptureConnection *)connection { //! OCLint
    @autoreleasepool {
        @try {
            if (!self.isVideoStreamEnable)
                return;
            [self recognizeWithSampleBuffer:sampleBuffer];
        } @catch (NSException *e) {
            NSLog(@"sampleBuffer exception:%@", e);
        }
    }
}

- (void)recognizeWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!CMSampleBufferIsValid(sampleBuffer))
        return;
    if ([self.cardRecognizer isKindOfClass:[STBankCardRecognizer class]]) {
        [self.cardRecognizer bankCardRecognizeWithSampleBuffer:sampleBuffer
                                           scanWindowVideoRect:self.scanVideoWindowRect];
    } else if ([self.cardRecognizer isKindOfClass:[STIdCardRecognizer class]]) {
        [self.cardRecognizer idCardRecognizeWithSampleBuffer:sampleBuffer scanWindowVideoRect:self.scanVideoWindowRect];
    }
}

@end
