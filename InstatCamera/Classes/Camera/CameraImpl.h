//
//  CameraImpl.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 18/06/2019.
//

#import <Foundation/Foundation.h>
#import "Camera.h"
@import AVFoundation.AVCaptureSessionPreset;
@protocol OutputSampleBufferDelegate;
@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

@interface CameraImpl : NSObject <Camera>
@property (nonatomic, readonly) AVCaptureSession* session;
@property (nonatomic, readonly) CameraStatus status;
@property (nonatomic, assign, readonly, getter=isRecording) BOOL recording;
@property (nonatomic, weak) id <OutputSampleBufferDelegate> delegate;

- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset;
- (void) startRecording;
- (void) stopRecording;
@end

NS_ASSUME_NONNULL_END
