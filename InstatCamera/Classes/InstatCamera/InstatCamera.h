//
//  InstatCamera.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVCaptureSessionPreset;
#import "InstatSessionPreset.h"

@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

@interface InstatCamera : NSObject
@property (nonatomic, readonly) AVCaptureSession *captureSession;

- (instancetype)initWithInstatCaptureSessionPreset:(InstatSessionPreset) instatSessionPreset;
@end

NS_ASSUME_NONNULL_END
