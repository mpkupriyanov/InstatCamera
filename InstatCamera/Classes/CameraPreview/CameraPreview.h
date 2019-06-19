//
//  CameraPreview.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <UIKit/UIKit.h>
@import AVFoundation.AVCaptureSession;
@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

@interface CameraPreview : UIView
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@end

NS_ASSUME_NONNULL_END
