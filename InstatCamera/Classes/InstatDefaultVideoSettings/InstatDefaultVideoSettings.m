//
//  InstatDefaultVideoSettings.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatDefaultVideoSettings.h"
@import AVFoundation;

@interface InstatDefaultVideoSettings()
@end
@implementation InstatDefaultVideoSettings

+ (NSDictionary *)videoSettingsWithSessionPreset:(InstatSessionPreset)sessionPreset {
    switch (sessionPreset) {
        case preset720:  return [InstatDefaultVideoSettings videoSettingsPreset720];
        case preset1080: return [InstatDefaultVideoSettings videoSettingsPreset1080];
        default:
            break;
    }
    return [InstatDefaultVideoSettings videoSettingsPreset720];
}

+ (NSDictionary *)videoSettingsPreset720 {
    return @{ AVVideoCodecKey: AVVideoCodecTypeH264,
              AVVideoHeightKey: @(720),
              AVVideoWidthKey: @(1280),
              AVVideoCompressionPropertiesKey: @{ AVVideoAverageBitRateKey: @(3000000),
                                                  AVVideoProfileLevelKey: AVVideoProfileLevelH264MainAutoLevel
              }
    };
}

+ (NSDictionary *)videoSettingsPreset1080 {
    return @{ AVVideoCodecKey: AVVideoCodecTypeH264,
              AVVideoHeightKey: @(1080),
              AVVideoWidthKey: @(1920),
              AVVideoCompressionPropertiesKey: @{ AVVideoAverageBitRateKey: @(7000000),
                                                  AVVideoProfileLevelKey: AVVideoProfileLevelH264MainAutoLevel
              }
    };
}
@end
