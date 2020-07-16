//
//  WriterImpl.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <Foundation/Foundation.h>
#import "Writer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WriterImpl : NSObject <Writer>
/// Value in seconds. By default 5 sec
@property (nonatomic, assign) NSTimeInterval chunkDuration;

- (instancetype)initWithVideoSettings:(NSDictionary *) videoSettings;
@end

NS_ASSUME_NONNULL_END
