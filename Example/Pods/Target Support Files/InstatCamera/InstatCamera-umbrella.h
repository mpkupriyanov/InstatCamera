#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Camera.h"
#import "CameraImpl.h"
#import "CameraPreview.h"
#import "InstatCamera.h"
#import "InstatSessionPreset.h"
#import "InstatCameraDelegate.h"
#import "InstatDefaultVideoSettings.h"
#import "InstatSessionPresetAdapter.h"
#import "OutputSampleBufferDelegate.h"
#import "RecordingTimer.h"
#import "RecordingTimerImpl.h"
#import "MKTimer.h"
#import "MKTimerImpl.h"
#import "Writer.h"
#import "WriterImpl.h"

FOUNDATION_EXPORT double InstatCameraVersionNumber;
FOUNDATION_EXPORT const unsigned char InstatCameraVersionString[];

