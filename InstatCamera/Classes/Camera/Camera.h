//
//  Camera.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 18/06/2019.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVCaptureSessionPreset;
@protocol OutputSampleBufferDelegate;
@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CameraStatus) {
    Success,
    NotAuthorized,
    SessionConfigurationFailed
};

@interface Camera : NSObject
@property (nonatomic, readonly) AVCaptureSession* session;
@property (nonatomic, readonly) CameraStatus status;
@property (nonatomic, weak) id <OutputSampleBufferDelegate> delegate;

- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset;
- (void) startRecording;
- (void) stopRecording;
@end

NS_ASSUME_NONNULL_END
