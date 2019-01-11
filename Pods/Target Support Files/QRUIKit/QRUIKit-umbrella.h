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

#import "QRAlertViewController.h"
#import "QRButtonAlertViewModel.h"
#import "QRCustomAlertViewModel.h"

FOUNDATION_EXPORT double QRUIKitVersionNumber;
FOUNDATION_EXPORT const unsigned char QRUIKitVersionString[];

