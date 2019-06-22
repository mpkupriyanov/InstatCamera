//
//  CameraImpl.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 18/06/2019.
//

#import "CameraImpl.h"
#import "OutputSampleBufferDelegate.h"
@import AVFoundation;

@interface CameraImpl () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureSessionPreset sessionPreset;
@property (nonatomic, assign, readwrite, getter=isRecording) BOOL recording;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, readwrite) CameraStatus status;

@property (nonatomic) dispatch_queue_t captureSampleBufferQueue;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

@end
@implementation CameraImpl

// MARK: - Life cycle
- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset)sessionPreset {
    self = [super init];
    if (self) {
        self.sessionPreset = sessionPreset;
        self.recording = false;
        [self setupSession];
    }
    return self;
}

- (void)dealloc {
    [self stopSession];
}

// MARK: - Public

- (void)startRecording {
    _recording = YES;
}

- (void)stopRecording {
    _recording = NO;
}

// MARK: - Private : Capture session setup

- (void)setupSession {
    
    _session = [[AVCaptureSession alloc] init];
    if ([_session canSetSessionPreset:_sessionPreset]) {
        _session.sessionPreset = _sessionPreset;
    }
    _sessionQueue = dispatch_queue_create("instat_camera.capture_session_queue", DISPATCH_QUEUE_SERIAL);
    [self videoAuthorizationStatus];
    dispatch_async(self.sessionQueue, ^{
        [self configureSession];
    });
}

- (void)startSession {
    
    dispatch_async(_sessionQueue, ^{
        [self.session startRunning];
    });
}

- (void)stopSession {
    
    if (_status == Success
        && self.session.isRunning == true) {
        dispatch_async(_sessionQueue, ^{
            [self.session stopRunning];
        });
    }
}

- (void)videoAuthorizationStatus {
    
    _status = Success;
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            // Already authorized status
            break;
            
        case AVAuthorizationStatusNotDetermined: {
            dispatch_suspend(_sessionQueue);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (!granted) {
                    self.status = NotAuthorized;
                }
                dispatch_resume(self.sessionQueue);
            }];
            break;
        }
            
        default:
            // You have restricted using camera
            _status = NotAuthorized;
            break;
    }
}

- (void)configureSession {
    
    if (_status != Success) {
        return;
    }
    
    NSError *error = nil;
    [_session beginConfiguration];
    // Add video input.
    AVCaptureDevice* videoDevice = [self availableVideoDevice];
    AVCaptureDeviceInput* videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (!videoDeviceInput) {
        NSLog(@"Could not create video device input: %@", error);
        _status = SessionConfigurationFailed;
        [_session commitConfiguration];
        return;
    }
    
    if ([self.session canAddInput:videoDeviceInput]) {
        [self.session addInput:videoDeviceInput];
    } else {
        NSLog(@"Could not add video device input to the session");
        self.status = SessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    
    // Add audio input.
    AVCaptureDevice* audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput* audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (!audioDeviceInput) {
        NSLog(@"Could not create audio device input: %@", error);
    }
    if ([self.session canAddInput:audioDeviceInput]) {
        [self.session addInput:audioDeviceInput];
    } else {
        NSLog(@"Could not add audio device input to the session");
    }
    
    [self setupDataOutput];
    [self.session commitConfiguration];
    [self startSession];
}

/// Get devices list
- (AVCaptureDevice *) availableVideoDevice {
    
    NSMutableArray<AVCaptureDeviceType> *avaliableDevicesType = [NSMutableArray array];
    if (@available(iOS 11.1, *)) {
        [avaliableDevicesType addObject:AVCaptureDeviceTypeBuiltInTrueDepthCamera];
    }
    if (@available(iOS 10.2, *)) {
        [avaliableDevicesType addObject:AVCaptureDeviceTypeBuiltInDualCamera];
    }
    // Add standart wide angle camera
    [avaliableDevicesType addObject:AVCaptureDeviceTypeBuiltInWideAngleCamera];
    
    NSArray<AVCaptureDeviceType>* deviceTypes = [NSArray arrayWithArray:avaliableDevicesType];
    AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    for (AVCaptureDevice *device in deviceDiscoverySession.devices) {
        return device;
    }
    return nil;
}

- (void)setupDataOutput {
    
    _captureSampleBufferQueue = dispatch_queue_create("instat_camera.capture_frame_queue", DISPATCH_QUEUE_SERIAL);
    // Video output
    AVCaptureVideoDataOutput *videoOutput = [AVCaptureVideoDataOutput new];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                   nil];
    
    videoOutput.videoSettings = videoSettings;
    [videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    if ([_session canAddOutput:videoOutput]) {
        [videoOutput setSampleBufferDelegate:self queue:_captureSampleBufferQueue];
        [_session addOutput:videoOutput];
    } else {
        NSLog(@"Could not add video output");
    }
    self.videoOutput = videoOutput;
    
    // Audio output
    AVCaptureAudioDataOutput *audioOutput = [AVCaptureAudioDataOutput new];
    if ([_session canAddOutput:audioOutput]) {
        [audioOutput setSampleBufferDelegate:self queue:_captureSampleBufferQueue];
        [_session addOutput:audioOutput];
    } else {
        NSLog(@"Could not add audio output");
    }
    self.audioOutput = audioOutput;
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFRetain(sampleBuffer);
    dispatch_async(_captureSampleBufferQueue, ^{
        if (self.isRecording) {
            if ([self.delegate respondsToSelector:@selector(writeSampleBuffer:ofType:)]) {
                if (output == self.videoOutput) {
                    [self.delegate writeSampleBuffer:sampleBuffer ofType:AVMediaTypeVideo];
                } else if (output == self.audioOutput) {
                    [self.delegate writeSampleBuffer:sampleBuffer ofType:AVMediaTypeAudio];
                }
            }
        }
        CFRelease(sampleBuffer);
    });
}
@end
