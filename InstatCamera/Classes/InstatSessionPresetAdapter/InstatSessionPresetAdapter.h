//
//  InstatSessionPresetAdapter.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <Foundation/Foundation.h>
@import AVFoundation.AVCaptureSessionPreset;
#import "InstatSessionPreset.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstatSessionPresetAdapter : NSObject

+ (AVCaptureSessionPreset)adapteeCaptureSessionPresetWith:(InstatSessionPreset) instatSessionPreset;

@end

NS_ASSUME_NONNULL_END
