//
//  InstatSessionPresetAdapter.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatSessionPresetAdapter.h"

@implementation InstatSessionPresetAdapter

+ (AVCaptureSessionPreset)adapteeCaptureSessionPresetWith:(InstatSessionPreset) instatSessionPreset {
    
    switch (instatSessionPreset) {
        case preset720: return AVCaptureSessionPreset1280x720;
        case preset1080: return AVCaptureSessionPreset1920x1080;
        default: break;
    }
    return AVCaptureSessionPreset1280x720;
}
@end
