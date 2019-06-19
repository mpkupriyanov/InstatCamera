//
//  InstatCamera.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatCamera.h"
#import "WriterImpl.h"
#import "Camera.h"
#import "InstatSessionPresetAdapter.h"
#import "InstatDefaultVideoSettings.h"

@interface InstatCamera ()
@property (nonatomic, strong) Camera *camera;
@property (nonatomic, strong) id<Writer> writer;
@property (nonatomic, assign) InstatSessionPreset instatSessionPreset;
@end
@implementation InstatCamera

// MARK: - Life cycle
- (instancetype)initWithInstatCaptureSessionPreset:(InstatSessionPreset) instatSessionPreset {
    self = [super init];
    if (self) {
        self.instatSessionPreset = instatSessionPreset;
        AVCaptureSessionPreset sessionPreset = [InstatSessionPresetAdapter adapteeCaptureSessionPresetWith:instatSessionPreset];
        [self setupCameraWith:sessionPreset];
        [self setupWriterWith:instatSessionPreset];
        self.camera.delegate = self.writer;
    }
    return self;
}

// MARK: - Public
- (AVCaptureSession *)captureSession {
    return _camera.session;
}

- (void)setDelegate:(id<InstatCameraDelegate>)delegate {
    _writer.delegate = delegate;
}

- (void)startRecording {
    [_camera startRecording];
}

- (void)stopRecording {
    [_camera stopRecording];
    [_writer finish];
}

- (void)clear {
    [_writer clear];
}

- (BOOL)isRecording {
    return _camera.isRecording;
}
// MARK: - Private : Camera
- (void)setupCameraWith:(AVCaptureSessionPreset) sessionPreset {
    
    Camera *camera = [[Camera alloc] initWithCaptureSessionPreset:sessionPreset];
    self.camera = camera;
}

// MARK: - Private : Writer
- (void)setupWriterWith:(InstatSessionPreset) instatSessionPreset {
    
    NSDictionary *defaultVideoSettings = [InstatDefaultVideoSettings videoSettingsWithSessionPreset:instatSessionPreset];
    WriterImpl *writer = [[WriterImpl alloc] initWithVideoSettings:defaultVideoSettings];
    self.writer = writer;
}
@end
