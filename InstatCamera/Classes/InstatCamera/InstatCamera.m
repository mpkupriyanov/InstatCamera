//
//  InstatCamera.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatCamera.h"
#import "Camera.h"

@interface InstatCamera ()
@property (nonatomic, strong) Camera *camera;
@end
@implementation InstatCamera

// MARK: - Life cycle
- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset {
    self = [super init];
    if (self) {
        Camera *camera = [[Camera alloc] initWithCaptureSessionPreset:sessionPreset];
        self.camera = camera;
    }
    return self;
}

// MARK: - Public
- (AVCaptureSession *)captureSession {
    return _camera.session;
}
@end
