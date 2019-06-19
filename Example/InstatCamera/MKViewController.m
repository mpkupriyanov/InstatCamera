//
//  MKViewController.m
//  InstatCamera
//
//  Created by mpkupriyanov on 06/18/2019.
//  Copyright (c) 2019 mpkupriyanov. All rights reserved.
//

#import "MKViewController.h"
#import <InstatCamera/InstatCamera.h>

@interface MKViewController ()
@property InstatCamera *camera;
@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    InstatCamera *camera = [[InstatCamera alloc] initWithCaptureSessionPreset:AVCaptureSessionPreset1280x720];
    self.camera = camera;
}

@end
