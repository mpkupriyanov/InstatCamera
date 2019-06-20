//
//  InstatCamera.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatCamera.h"
#import "WriterImpl.h"
#import "CameraImpl.h"
#import "InstatSessionPresetAdapter.h"
#import "InstatDefaultVideoSettings.h"
#import "RecordingTimerImpl.h"

@interface InstatCamera ()
@property (nonatomic, strong) id<Camera> camera;
@property (nonatomic, strong) id<Writer> writer;
@property (nonatomic, strong) id<RecordingTimer> timer;
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
        [self setupRecordingTimer];
    }
    return self;
}

- (void)dealloc {
    
    if (_camera.isRecording) {
        [_camera stopRecording];
    }
    [_timer cancel];
}

// MARK: - Public
- (AVCaptureSession *)captureSession {
    return _camera.session;
}

- (void)setDelegate:(id<InstatCameraDelegate>)delegate {
    _writer.delegate = delegate;
    _timer.delegate = delegate;
}

- (void)startRecording {
    
    [_camera startRecording];
    [_timer start];
}

- (void)stopRecording {
    
    [_camera stopRecording];
    [_writer finish];
    [_timer cancel];
}

- (void)clear {
    [_writer clear];
    [_timer clear];
}

- (BOOL)isRecording {
    return _camera.isRecording;
}
// MARK: - Private : Camera
- (void)setupCameraWith:(AVCaptureSessionPreset) sessionPreset {
    
    CameraImpl *camera = [[CameraImpl alloc] initWithCaptureSessionPreset:sessionPreset];
    self.camera = camera;
}

// MARK: - Private : Writer
- (void)setupWriterWith:(InstatSessionPreset) instatSessionPreset {
    
    NSDictionary *defaultVideoSettings = [InstatDefaultVideoSettings videoSettingsWithSessionPreset:instatSessionPreset];
    WriterImpl *writer = [[WriterImpl alloc] initWithVideoSettings:defaultVideoSettings];
    self.writer = writer;
}

// MARK: - Private : Timer

- (void)setupRecordingTimer {
    
    RecordingTimerImpl *timer = [RecordingTimerImpl new];
    self.timer = timer;
}
@end
