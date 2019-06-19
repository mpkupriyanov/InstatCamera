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

@interface MKViewController ()
@property (nonatomic, weak) IBOutlet CameraPreview *cameraPreview;
@property (nonatomic, strong) InstatCamera *instatCamera;
@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    InstatCamera *camera = [[InstatCamera alloc] initWithCaptureSessionPreset:AVCaptureSessionPreset1280x720];
    
    _cameraPreview.captureSession = camera.captureSession;
    self.instatCamera = camera;
}

@end
