//
//  WriterImpl.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "WriterImpl.h"
@import AVFoundation;

static const NSTimeInterval kDefaultChunkDuration = 5.000f;

@interface WriterImpl()
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoAssetWriterInput;
@property (nonatomic, strong) AVAssetWriterInput *audioAssetWriterInput;

@property (nonatomic, assign) CMTime chunkStartTime;
@property (nonatomic, assign) NSInteger chunkNumber;
@property (nonatomic, strong) NSURL *chunkOutputURL;
@property (nonatomic, strong) NSDictionary *videoSettings;
@end
@implementation WriterImpl

- (instancetype)initWithVideoSettings:(NSDictionary *) videoSettings
{
    self = [super init];
    if (self) {
        self.chunkDuration = kDefaultChunkDuration;
        self.videoSettings = videoSettings;
    }
    return self;
}

- (void) createWriterInputWith:(CMTime) presentationTimeStamp {
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@out%06ld.mov", NSTemporaryDirectory(), _chunkNumber];
    NSURL *chunkOutputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    _chunkOutputURL = chunkOutputURL;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO) {
            // Обработка ошибки при удалении
            NSLog(@"Can't remove file");
        }
    }
    
    NSError *assetWriterError;
    _assetWriter = [AVAssetWriter assetWriterWithURL:chunkOutputURL fileType:AVFileTypeQuickTimeMovie error:&assetWriterError];
    if (assetWriterError || _assetWriter == nil) {
        NSLog(@"Error Setting assetWriter: %@", assetWriterError);
    }
    
    // TODO: get dimensions from image CMSampleBufferGetImageBuffer(sampleBuffer)
    
    // Video input
    _videoAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings: _videoSettings];
    _videoAssetWriterInput.expectsMediaDataInRealTime = YES;
    
    if ([_assetWriter canAddInput:_videoAssetWriterInput]) {
        [_assetWriter addInput:_videoAssetWriterInput];
    }
    
    // Audio input
    _audioAssetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings: nil];
    _audioAssetWriterInput.expectsMediaDataInRealTime = YES;
    
    if ([_assetWriter canAddInput:_audioAssetWriterInput]) {
        [_assetWriter addInput:_audioAssetWriterInput];
    }

    _chunkNumber += 1;
    _chunkStartTime = presentationTimeStamp;
    
    [_assetWriter startWriting];
    [_assetWriter startSessionAtSourceTime: _chunkStartTime];
}

// MARK: - OutputSampleBufferDelegate
- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(AVMediaType)mediaType {
    
    CMTime presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if (_assetWriter == nil) {
        [self createWriterInputWith:presentationTimeStamp];
    } else {
        Float64 currentChunkDuration = CMTimeGetSeconds(CMTimeSubtract(presentationTimeStamp, _chunkStartTime));
        
        if (_chunkNumber >= 4) {
//            [self stopRecording];
        }
        if (currentChunkDuration > _chunkDuration) {
            [_assetWriter endSessionAtSourceTime:presentationTimeStamp];
            
            // make a copy, as finishWriting is asynchronous
            NSURL *newChunkURL = _chunkOutputURL;
            AVAssetWriter *chunkAssetWriter = _assetWriter;
           
            [chunkAssetWriter finishWritingWithCompletionHandler:^{
                
                NSLog(@"finishWriting says: %ld, error: %@", (long)chunkAssetWriter.status, chunkAssetWriter.error);
                NSLog(@"url: %@", newChunkURL.absoluteString);
                // Отправляем на перекодировку
                //                [self converterFile: newChunkURL number:chunkNumber];
                
            }];
            [self createWriterInputWith:presentationTimeStamp];
        }
    }
    
    if (mediaType == AVMediaTypeAudio) {
        if (_audioAssetWriterInput.readyForMoreMediaData) {
            if (![_audioAssetWriterInput appendSampleBuffer: sampleBuffer]) {
                NSLog(@"append says NO: %ld, %@", (long)_assetWriter.status, _assetWriter.error);
            }
        }
    } else {
        if (_videoAssetWriterInput.readyForMoreMediaData) {
            if (![_videoAssetWriterInput appendSampleBuffer: sampleBuffer]) {
                NSLog(@"video append says NO: %ld, %@", (long)_assetWriter.status, _assetWriter.error);
            }
        }
    }
}
@end
