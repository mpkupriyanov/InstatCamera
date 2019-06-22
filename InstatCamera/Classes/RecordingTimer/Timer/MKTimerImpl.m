//
//  MKTimerImpl.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 20/06/2019.
//

#import "MKTimerImpl.h"
#import <dispatch/dispatch.h>

static dispatch_source_t createDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

@interface MKTimerImpl()
@property dispatch_source_t timer;
@property dispatch_block_t block;
@property NSTimeInterval secondsToFire;
@end

@implementation MKTimerImpl

// MARK: - Life cycle
- (instancetype) initWithSecondsToFire:(NSTimeInterval)seconds block:(dispatch_block_t) block {
    self = [super init];
    if (self) {
        self.block = block;
        self.secondsToFire = seconds;
        [self createTimer];
    }
    return self;
}

- (void) dealloc {
    dispatch_source_cancel(_timer);
}

// MARK: - Public
- (void) start {
    [self createTimer];
}

- (void) cancel {
    dispatch_source_cancel(_timer);
}

- (BOOL) isValid {
    return _timer && 0 == dispatch_source_testcancel(_timer);
}

// MARK: - Private
- (void) createTimer {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = createDispatchTimer(_secondsToFire, queue, _block);
}
@end
