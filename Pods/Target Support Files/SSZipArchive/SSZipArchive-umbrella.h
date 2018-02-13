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

#import "SSZipArchive.h"
#import "crypt.h"
#import "ioapi.h"
#import "mztools.h"
#import "unzip.h"
#import "zip.h"

FOUNDATION_EXPORT double SSZipArchiveVersionNumber;
FOUNDATION_EXPORT const unsigned char SSZipArchiveVersionString[];

