//
//  MKViewController.m
//  InstatCamera
//
//  Created by mpkupriyanov on 06/18/2019.
//  Copyright (c) 2019 mpkupriyanov. All rights reserved.
//

#import "MKViewController.h"
#import <InstatCamera/InstatCamera.h>
#import <InstatCamera/CameraPreview.h>
@import AVFoundation.AVCaptureSession;

@interface MKViewController () <InstatCameraDelegate>
@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, weak) IBOutlet CameraPreview *cameraPreview;
@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (nonatomic, strong) InstatCamera *instatCamera;
@property (nonatomic, strong) NSMutableArray<NSURL *> *chunkURLArray;

@property (nonatomic, assign) CGFloat minimumZoom;
@property (nonatomic, assign) CGFloat maximumZoom;
@property (nonatomic, assign) CGFloat lastZoomFactor;
@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    InstatCamera *camera = [[InstatCamera alloc] initWithInstatCaptureSessionPreset:preset720];
    camera.delegate = self;
    self.instatCamera = camera;
    self.cameraPreview.captureSession = camera.captureSession;
    self.chunkURLArray = [NSMutableArray array];
    [self setupButtons];
    [self zoomSetup];
}

- (void) viewWillTransitionToSize:(CGSize)size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [self setupVideoOrientation];
}

- (void)setupVideoOrientation {

    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    _cameraPreview.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
}

// MARK: - Action

- (IBAction)toggleRecording:(id)sender {
    
    if (_instatCamera.isRecording) {
        [_instatCamera stopRecording];
    } else {
        [_instatCamera startRecording];
    }
    [self updateUI];
}

- (IBAction)shareButtonPressed:(id)sender {
    [self share];
}

- (IBAction)removeButtonPressed:(id)sender {
    
    [self removeAllFiles];
    [_instatCamera clear];
    [self updateButtons];
}

// MARK: - Zoom
- (IBAction)zoomPinchGesture:(UIPinchGestureRecognizer *)recognizer {
    [self pinchState:recognizer.state scale:recognizer.scale];
}

// MARK: - Private : UI
- (void)updateUI {

    NSString *title;
    if (_instatCamera.isRecording) {
        title = @"Stop";
    } else {
        title = @"Start";
    }
    [self updateButtons];
    [_toggleButton setTitle:title forState:UIControlStateNormal];
}

- (void)updateButtons {
    _removeButton.enabled = _shareButton.enabled = _chunkURLArray.count > 0;
}

// MARK: - Private : Button

- (void)setupButtons {
    
    for(UIButton *button in _buttons) {
        button.layer.cornerRadius = 6;
        button.layer.borderWidth = 1;
        button.layer.borderColor = button.tintColor.CGColor;
    }
}

// MARK: - Private : Share

- (void)share {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:self.chunkURLArray applicationActivities:nil];
        NSArray *excludeActivities = @[
                                       UIActivityTypePrint,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo];
        activityVC.excludedActivityTypes = excludeActivities;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:activityVC animated:YES completion:nil];
        });
    });
}

// MARK: - Private
- (void)removeAllFiles {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSURL *url in _chunkURLArray) {
        if ([fileManager fileExistsAtPath:url.absoluteString]) {
            NSError *error;
            if ([fileManager removeItemAtURL:url error:&error] == NO) {
                // Обработка ошибки при удалении
                NSLog(@"Could not remove file: %@", url.absoluteString);
            }
        }
    }
    [_chunkURLArray removeAllObjects];
}

// MARK: - InstatCameraDelegate
- (void)completedChunkFileURL:(NSURL *) file_url {
    
    [_chunkURLArray addObject:file_url];
    // Share all files when stoped recording
    if (_instatCamera.isRecording == false) {
        [self updateButtons];
        if (_shareSwitch.isOn == true) {
            
            [self share];
        }
    }
    NSLog(@"%@", file_url.absoluteString);
}

- (void)recordingTime:(NSString *)time {
    _timerLabel.text = time;
}

- (void)sessionWasInterrupted {
    [self updateUI];
}

- (void)sessionInterruptionEnded {
    
}

// MARK: - Private : zoom
- (void)zoomSetup {
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomPinchGesture:)];
    [_cameraPreview addGestureRecognizer:pinch];
    
    _minimumZoom = 1.0;
    _maximumZoom = 7.0;
    _lastZoomFactor = 1.0;
}

- (void)pinchState:(UIGestureRecognizerState)state scale:(CGFloat) scale {
    
    CGFloat newScaleFactor = [self minMaxZoom: scale * _lastZoomFactor];
    switch (state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            [_instatCamera zoom:newScaleFactor];
            break;
            
        case UIGestureRecognizerStateEnded:
            _lastZoomFactor = [self minMaxZoom:newScaleFactor];
            [_instatCamera zoom: _lastZoomFactor];
            break;
            
        default:
            break;
    }
}

- (CGFloat)minMaxZoom:(CGFloat)factor {
    return MIN(MIN(MAX(factor, _minimumZoom), _maximumZoom), _instatCamera.maxZoomFactor);
}
@end
