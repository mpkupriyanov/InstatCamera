//
//  Camera.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 20/06/2019.
//

#ifndef Camera_h
#define Camera_h
@import AVFoundation.AVCaptureSessionPreset;
@protocol OutputSampleBufferDelegate;
@class AVCaptureSession;

typedef NS_ENUM(NSInteger, CameraStatus) {
    Success,
    NotAuthorized,
    SessionConfigurationFailed
};

@protocol Camera <NSObject>
@property (nonatomic, readonly) AVCaptureSession* session;
@property (nonatomic, readonly) CameraStatus status;
@property (nonatomic, assign, readonly, getter=isRecording) BOOL recording;
@property (nonatomic, weak) id <OutputSampleBufferDelegate> delegate;

- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset;
- (void)startRecording;
- (void)stopRecording;

// MARK: - Zoom
@property (nonatomic, assign, readonly) CGFloat maxZoomFactor;
- (void)setZoom:(CGFloat)zoomLevel;
- (void)setZoomRate:(CGFloat)zoomRate;
- (void)zoomStop;
- (CGFloat)currentZoomFactor;
@end
#endif /* Camera_h */
