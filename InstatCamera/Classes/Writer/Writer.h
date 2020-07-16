//
//  Writer.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#ifndef Writer_h
#define Writer_h
#import "OutputSampleBufferDelegate.h"
@protocol InstatCameraDelegate;

@protocol Writer <NSObject, OutputSampleBufferDelegate>
@property (nonatomic, weak) id <InstatCameraDelegate> delegate;
/// Finish last chunk
- (void)finish;
/// Clear number of chunks
- (void)clear;
- (void)saveToPath:(NSString *) path;
@end
#endif /* Writer_h */
