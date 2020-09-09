//
//  InstatCamera.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVCaptureSessionPreset;
@import AVFoundation.AVCaptureSession;
#import "InstatSessionPreset.h"
#import "InstatCameraDelegate.h"

@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

@interface InstatCamera : NSObject
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, weak) id <InstatCameraDelegate> delegate;

- (instancetype)initWithInstatCaptureSessionPreset:(InstatSessionPreset) instatSessionPreset;
- (void)startRecording;
- (void)stopRecording;
- (void)reset;
- (void)saveToPath:(NSString *) path;
- (void)setCaptureVideoOrientation:(AVCaptureVideoOrientation)videoOrientation;
// MARK: - Zoom
@property (nonatomic, assign, readonly) CGFloat maxZoomFactor;
- (void)setZoom:(CGFloat)zoomLevel;
- (void)setZoomRate:(CGFloat)zoomRate;
- (void)zoomStop;
@end

NS_ASSUME_NONNULL_END
