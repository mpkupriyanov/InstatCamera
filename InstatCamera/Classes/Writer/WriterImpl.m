//
//  WriterImpl.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "WriterImpl.h"
#import "InstatCameraDelegate.h"
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
@property (nonatomic, strong) NSString *savePath;
@property (nonatomic, assign) AVCaptureVideoOrientation currentVideoOrientation;
@property (nonatomic, assign) BOOL needChangeOrientation;
@end

@implementation WriterImpl
@synthesize delegate;

// MARK: - Life cycle
- (instancetype)initWithVideoSettings:(NSDictionary *) videoSettings {
    self = [super init];
    if (self) {
        self.chunkDuration = kDefaultChunkDuration;
        self.chunkNumber = 0;
        self.videoSettings = videoSettings;
        self.currentVideoOrientation = AVCaptureVideoOrientationLandscapeRight; // Default orientation, home button on the right
    }
    return self;
}

// MARK: - Public
- (void)finish {
    
    NSURL *url = _chunkOutputURL;
    AVAssetWriter *chunkAssetWriter = _assetWriter;
    [self finishAssetWriter:chunkAssetWriter url:url];
    _assetWriter = nil;
    _chunkOutputURL = nil;
    _chunkStartTime = kCMTimeZero;
}

- (void)clear {
    _chunkNumber = 0;
}

- (void)saveToPath:(NSString *)path {
    self.savePath = path;
}

- (void)setCaptureVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    if (_currentVideoOrientation != videoOrientation) {
        _currentVideoOrientation = videoOrientation;
        _needChangeOrientation = true;
    }
}

// MARK: - Private
- (void)setOrientationTo:(AVAssetWriterInput *)assetWriterInput {
    if (_needChangeOrientation) {
        _needChangeOrientation = false;
        assetWriterInput.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (NSString *)fileName {
    return [[NSString alloc] initWithFormat:@"out%06ld.mov", (long)_chunkNumber];
}

- (void)createWriterInputWith:(CMTime) presentationTimeStamp {
    
    NSURL *chunkOutputURL = [[NSURL alloc] initFileURLWithPath:_savePath];
    chunkOutputURL = [chunkOutputURL URLByAppendingPathComponent:[self fileName]];
    _chunkOutputURL = chunkOutputURL;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = chunkOutputURL.path;
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error;
        if ([fileManager removeItemAtPath:path error:&error] == NO) {
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
    [self setOrientationTo:_videoAssetWriterInput];
    
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

- (void)finishAssetWriter:(AVAssetWriter *)assetWriter url:(NSURL *) url {
    
    [assetWriter finishWritingWithCompletionHandler:^{
        NSLog(@"finishWriting says: %ld, error: %@", (long)assetWriter.status, assetWriter.error);
        if ([self.delegate respondsToSelector:@selector(completedChunkFileURL:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate completedChunkFileURL:url];
            });
        }
    }];
}

// MARK: - OutputSampleBufferDelegate
- (void)writeSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(AVMediaType)mediaType {
    
    CMTime presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    if (_assetWriter == nil) {
        [self createWriterInputWith:presentationTimeStamp];
    } else {
        Float64 currentChunkDuration = CMTimeGetSeconds(CMTimeSubtract(presentationTimeStamp, _chunkStartTime));
        
        if (currentChunkDuration > _chunkDuration) {
            [_assetWriter endSessionAtSourceTime:presentationTimeStamp];
            
            NSURL *url = _chunkOutputURL;
            AVAssetWriter *chunkAssetWriter = _assetWriter;
            [self finishAssetWriter:chunkAssetWriter url:url];
            [self createWriterInputWith:presentationTimeStamp];
        }
    }
    
    if (mediaType == AVMediaTypeAudio) {
        if (_audioAssetWriterInput.readyForMoreMediaData) {
            if (![_audioAssetWriterInput appendSampleBuffer: sampleBuffer]) {
                NSLog(@"audio append says NO: %ld, %@", (long)_assetWriter.status, _assetWriter.error);
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
