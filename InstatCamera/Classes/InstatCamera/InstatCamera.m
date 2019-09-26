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
@import AVFoundation.AVCaptureSession;

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
        [self addObservers];
    }
    return self;
}

- (void)dealloc {
    
    if (_camera.isRecording) {
        [_camera stopRecording];
    }
    [_timer cancel];
    [self removeObservers];
}

// MARK: - Public
- (AVCaptureSession *)captureSession {
    return _camera.session;
}

- (void)setDelegate:(id<InstatCameraDelegate>)delegate {
    
    _delegate = delegate;
    _writer.delegate = delegate;
    _timer.delegate = delegate;
}

- (void)startRecording {
    
    [_camera startRecording];
    [_timer start];
}

- (void)stopRecording {
    
    [_camera stopRecording];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.writer finish];
        [self.timer cancel];
    });
}

- (void)clear {
    [_writer clear];
    [_timer clear];
}

- (BOOL)isRecording {
    return _camera.isRecording;
}

// MARK: Public : Zoom
- (void)zoomIn {
    [_camera zoomIn];
}

- (void)zoomOut {
    [_camera zoomOut];
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

// MARK: - Private : Notifications

- (void)addObservers {
    
    /*
     A session can only run when the app is full screen. It will be interrupted
     in a multi-app layout, introduced in iOS 9, see also the documentation of
     AVCaptureSessionInterruptionReason. Add observers to handle these session
     interruptions and show a preview is paused message. See the documentation
     of AVCaptureSessionWasInterruptedNotification for other interruption reasons.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:_camera.session];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:_camera.session];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - Private : Interruption session

- (void)sessionWasInterrupted:(NSNotification *) notification {
    
    AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
    NSLog(@"Capture session was interrupted with reason %ld", (long)reason);
    if (reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient ||
        reason == AVCaptureSessionInterruptionReasonVideoDeviceInUseByAnotherClient) {
        NSLog(@"Video or audio device in use another client");
    } else if (reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps) {
        // Fade-in a label to inform the user that the camera is unavailable.
         NSLog(@"Camera is unavailable");
    } else if (@available(iOS 11.1, *)) {
        if (reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableDueToSystemPressure) {
            NSLog(@"Session stopped running due to shutdown system pressure level");
        }
    }
    if (self.isRecording) {
        [self stopRecording];
    }
    if ([_delegate respondsToSelector:@selector(sessionWasInterrupted)]) {
        [_delegate sessionWasInterrupted];
    }
}

- (void)sessionInterruptionEnded:(NSNotification*)notification {
    
    NSLog(@"Capture session interruption ended");
    if ([_delegate respondsToSelector:@selector(sessionInterruptionEnded)]) {
        [_delegate sessionInterruptionEnded];
    }
}
@end
