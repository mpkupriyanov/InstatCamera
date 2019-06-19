//
//  InstatDefaultVideoSettings.m
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import "InstatDefaultVideoSettings.h"
@import AVFoundation.AVVideoSettings;

@interface InstatDefaultVideoSettings()
@property (nonatomic, assign) InstatSessionPreset sessionPreset;
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
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    if (@available(iOS 11.0, *)) {
        settings[AVVideoCodecKey] = AVVideoCodecTypeH264;
    } else {
        settings[AVVideoCodecKey] = AVVideoCodecH264;
    }
    settings[AVVideoHeightKey] = @(720);
    settings[AVVideoWidthKey] = @(1280);
    settings[AVVideoCompressionPropertiesKey] = @{ AVVideoAverageBitRateKey: @(3000000),
                                                   AVVideoProfileLevelKey: AVVideoProfileLevelH264MainAutoLevel
                                                   };
    return settings;
}

+ (NSDictionary *)videoSettingsPreset1080 {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    if (@available(iOS 11.0, *)) {
        settings[AVVideoCodecKey] = AVVideoCodecTypeH264;
    } else {
        settings[AVVideoCodecKey] = AVVideoCodecH264;
    }
    settings[AVVideoHeightKey] = @(1080);
    settings[AVVideoWidthKey] = @(1920);
    settings[AVVideoCompressionPropertiesKey] = @{ AVVideoAverageBitRateKey: @(7000000),
                                                   AVVideoProfileLevelKey: AVVideoProfileLevelH264MainAutoLevel
                                                   };
    return settings;
}
@end
