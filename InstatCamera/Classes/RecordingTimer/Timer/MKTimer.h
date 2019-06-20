//
//  MKTimer.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 20/06/2019.
//

#ifndef MKTimer_h
#define MKTimer_h

@protocol MKTimer <NSObject>

- (instancetype) initWithSecondsToFire:(NSTimeInterval)seconds block:(dispatch_block_t) block;
- (void)start;
- (void)cancel;
- (BOOL)isValid;
@end
#endif /* MKTimer_h */
