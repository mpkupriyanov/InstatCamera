//
//  InstatCameraDelegate.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#ifndef InstatCameraDelegate_h
#define InstatCameraDelegate_h
@import Foundation.NSURL;

@protocol InstatCameraDelegate <NSObject>

@optional
- (void)completedChunkNumber:(NSInteger)number fileURL:(NSURL *)file_url;
- (void)recordingTime:(NSString *)time;
- (void)sessionWasInterrupted;
- (void)sessionInterruptionEnded;
@end
#endif /* InstatCameraDelegate_h */
