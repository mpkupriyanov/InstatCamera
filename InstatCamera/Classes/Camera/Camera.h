//
//  Camera.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 18/06/2019.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVCaptureSessionPreset;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CameraStatus) {
    Success,
    NotAuthorized,
    SessionConfigurationFailed
};

@interface Camera : NSObject
@property (readonly) CameraStatus status;

- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset;
- (void) startRecording;
- (void) stopRecording;
@end

NS_ASSUME_NONNULL_END
