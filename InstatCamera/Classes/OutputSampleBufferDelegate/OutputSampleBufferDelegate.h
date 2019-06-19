//
//  OutputSampleBufferDelegate.h
//  Pods
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#ifndef OutputSampleBufferDelegate_h
#define OutputSampleBufferDelegate_h
@import AVFoundation.AVMediaFormat;
@import CoreMedia.CMSampleBuffer;

@protocol OutputSampleBufferDelegate <NSObject>
- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   ofType:(AVMediaType)mediaType;
@end

#endif /* OutputSampleBufferDelegate_h */
