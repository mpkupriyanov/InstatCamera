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
@end
