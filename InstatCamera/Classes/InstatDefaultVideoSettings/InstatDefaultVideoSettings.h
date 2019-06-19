//
//  InstatDefaultVideoSettings.h
//  InstatCamera
//
//  Created by Mikhail Kupriyanov on 19/06/2019.
//

#import <Foundation/Foundation.h>
#import "InstatSessionPreset.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstatDefaultVideoSettings : NSObject
+ (NSDictionary *)videoSettingsWithSessionPreset:(InstatSessionPreset)sessionPreset;
@end

NS_ASSUME_NONNULL_END
