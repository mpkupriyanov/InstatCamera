//
//  InstatCamera.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVCaptureSessionPreset;

NS_ASSUME_NONNULL_BEGIN

@interface InstatCamera : NSObject
- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset;
@end

NS_ASSUME_NONNULL_END
