//
//  InstatCamera.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatCamera.h"
#import "WriterImpl.h"
#import "Camera.h"

@interface InstatCamera ()
@property (nonatomic, strong) Camera *camera;
@property (nonatomic, strong) id<Writer> writer;
@end
@implementation InstatCamera

// MARK: - Life cycle
- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset {
    self = [super init];
    if (self) {
        
        [self setupCameraWith:sessionPreset];
        [self setupWriter];
    }
    return self;
}

// MARK: - Public
- (AVCaptureSession *)captureSession {
    return _camera.session;
}

// MARK: - Private : Camera
- (void)setupCameraWith:(AVCaptureSessionPreset) sessionPreset {
    
    Camera *camera = [[Camera alloc] initWithCaptureSessionPreset:sessionPreset];
    self.camera = camera;
}

// MARK: - Private : Writer
- (void)setupWriter {
    
    WriterImpl *writer = [WriterImpl new];
    
    self.writer = writer;
}
@end
