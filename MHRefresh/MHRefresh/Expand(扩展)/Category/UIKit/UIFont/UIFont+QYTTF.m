//
//  UIFont+QYTTF.m
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIFont+QYTTF.h"
#import <CoreText/CoreText.h>

@implementation UIFont (QYTTF)

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size {
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];

    NSAssert(isExist, @"The path %@ not exist", path);
    
    if (!isExist) {
        return [UIFont systemFontOfSize:size];
    }
    
    CFURLRef fontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)path, kCFURLPOSIXPathStyle, false);;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(fontURL);
    CFRelease(fontURL);
    CGFontRef graphicsFont = CGFontCreateWithDataProvider(dataProvider);
    CFRelease(dataProvider);
    CTFontRef smallFont = CTFontCreateWithGraphicsFont(graphicsFont, size, NULL, NULL);
    CFRelease(graphicsFont);
    
    UIFont *returnFont = (__bridge UIFont *)smallFont;
    CFRelease(smallFont);
    
    return returnFont;
}

+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size {
    
    BOOL isLocalUrl = [URL isFileURL];
    
    if (isLocalUrl) {
        return [UIFont fontWithTTFAtPath:URL.path size:size];
    }

    NSAssert(isLocalUrl, @"The path of %@ is not a local path", URL.path);
    
    return [UIFont systemFontOfSize:size];
}

@end
