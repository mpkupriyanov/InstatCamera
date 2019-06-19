//
//  CameraPreview.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;

NS_ASSUME_NONNULL_BEGIN

@interface CameraPreview : UIView
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@end

NS_ASSUME_NONNULL_END
