//
//  InstatCamera.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatCamera.h"
#import "Camera.h"

@interface InstatCamera ()
@property Camera *camera;
@end
@implementation InstatCamera

- (instancetype)initWithCaptureSessionPreset:(AVCaptureSessionPreset) sessionPreset {
    self = [super init];
    if (self) {
        Camera *camera = [[Camera alloc] initWithCaptureSessionPreset:sessionPreset];
        self.camera = camera;
    }
    return self;
}
@end
