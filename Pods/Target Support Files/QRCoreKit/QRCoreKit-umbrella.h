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

#import "NSError+WSErrors.h"
#import "NSString+QRUserGender.h"
#import "SKProduct+FormatPrice.h"
#import "UIButton+QRAdditions.h"
#import "UIView+AutoLayoutDebugging.h"
#import "UIView+FindFirstResponder.h"
#import "CustomUnwindSegueProtocol.h"
#import "FactoryUnwind.h"
#import "QRLocalizer.h"
#import "QRUtils.h"

FOUNDATION_EXPORT double QRCoreKitVersionNumber;
FOUNDATION_EXPORT const unsigned char QRCoreKitVersionString[];

