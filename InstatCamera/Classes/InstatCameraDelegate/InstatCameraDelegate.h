//
//  InstatCameraDelegate.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#ifndef InstatCameraDelegate_h
#define InstatCameraDelegate_h
@import Foundation;

@protocol InstatCameraDelegate <NSObject>

- (void)finishFileURL:(NSURL *) file_url;

@end
#endif /* InstatCameraDelegate_h */
