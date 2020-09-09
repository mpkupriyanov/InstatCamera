//
//  RecordingTimer.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 20/06/2019.
//

#ifndef RecordingTimer_h
#define RecordingTimer_h
@protocol InstatCameraDelegate;

@protocol RecordingTimer <NSObject>
@property (nonatomic, weak) id <InstatCameraDelegate> delegate;

- (void)start;
- (void)cancel;
- (void)reset;
@end
#endif /* RecordingTimer_h */
