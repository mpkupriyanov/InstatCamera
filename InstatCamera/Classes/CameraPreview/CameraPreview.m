//
//  CameraPreview.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "CameraPreview.h"
@import AVFoundation;

@implementation CameraPreview

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoPreviewLayer *) videoPreviewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (AVCaptureSession *) captureSession {
    return self.videoPreviewLayer.session;
}

- (void)setVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    self.videoPreviewLayer.connection.videoOrientation = videoOrientation;
}

- (void)setCaptureSession:(AVCaptureSession *) session {
    
    self.videoPreviewLayer.session = session;
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}
@end
