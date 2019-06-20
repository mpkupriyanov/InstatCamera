//
//  MKTimerImpl.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 20/06/2019.
//

#import <Foundation/Foundation.h>
#import "MKTimer.h"
NS_ASSUME_NONNULL_BEGIN

@interface MKTimerImpl : NSObject <MKTimer>
- (instancetype) initWithSecondsToFire:(NSTimeInterval)seconds block:(dispatch_block_t) block;
@end

NS_ASSUME_NONNULL_END
