//
//  RecordingTimerImpl.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 20/06/2019.
//

#import "RecordingTimerImpl.h"
#import "MKTimerImpl.h"
#import "InstatCameraDelegate.h"

@interface RecordingTimerImpl ()
@property (nonatomic, strong) id<MKTimer> timer;
@property (nonatomic, assign) NSTimeInterval time;
@end
@implementation RecordingTimerImpl
@synthesize delegate;

// MARK: - Public
- (void)start {
    
    if ([_timer isValid] == false) {
        [self createTimer];
    }
}

- (void)cancel {
    
    [_timer cancel];
    _timer = nil;
}

- (void)reset {
    
    _time = 0;
    [self dispatchTime];
}

// MARK: - Private
- (void)createTimer {
    
    double recordingTimer = 1.000f;
    __weak typeof(self) weakSelf = self;
    _timer = [[MKTimerImpl alloc] initWithSecondsToFire:recordingTimer block:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf timerBlock];
    }];
}

- (void)dispatchTime {
    
    NSString *time = [self formattedDuration:_time];
    if ([self.delegate respondsToSelector:@selector(recordingTime:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate recordingTime:time];
        });
    }
}

- (void)timerBlock {
    
    _time += 1;
    [self dispatchTime];
}

/// Timer - hh:mm:ss
- (NSString *)formattedDuration:(NSInteger)time {
    
    NSInteger hours = time / 3600;
    NSInteger minutes = (time % 3600) / 60;
    NSInteger seconds = (time % 3600) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
@end
