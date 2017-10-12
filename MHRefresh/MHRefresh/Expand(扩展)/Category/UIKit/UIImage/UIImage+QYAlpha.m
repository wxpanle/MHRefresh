//
//  UIImage+QYAlpha.m
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIImage+QYAlpha.h"

static const size_t kBitsPerComponent = 8;

@implementation UIImage (QYAlpha)

- (BOOL)hasAlpha {
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    
    if (alphaInfo == kCGImageAlphaFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaPremultipliedLast) {
        
        return YES;
    }
    
    return NO;
}

- (UIImage *)imageWithAlpha {
    
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, kBitsPerComponent, 0, CGImageGetColorSpace(imageRef), kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
    
}

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, newRect.size.width, newRect.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

//http://stackoverflow.com/questions/6521987/crop-uiimage-to-alpha?answertab=oldest#tab-top
- (UIImage *)trimmedBetterSize {
    
    CGImageRef inImage = self.CGImage;
    CFDataRef m_DataRef;
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    CGFloat width = CGImageGetWidth(inImage);
    CGFloat height = CGImageGetHeight(inImage);

    CGPoint top, left, right, bottom;
    
    BOOL breakOut = NO;
    for (int x = 0; breakOut == NO && x < width; x++) {
        for (int y = 0; y < height; y++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0; breakOut == NO && y < height; y++) {
        for (int x = 0; x < width; x++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = height-1; breakOut == NO && y >= 0; y--) {
        for (int x = width-1; x >= 0; x--) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int x = width-1; breakOut == NO && x >= 0; x--) {
        for (int y = height-1; y >= 0; y--) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    
    CGFloat scale = self.scale;
    
    CGRect cropRect = CGRectMake(left.x / scale, top.y / scale, (right.x - left.x) / scale, (bottom.y - top.y) / scale);
    UIGraphicsBeginImageContextWithOptions( cropRect.size,
                                           NO,
                                           scale);
    [self drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y)
            blendMode:kCGBlendModeCopy
                alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CFRelease(m_DataRef);
    return croppedImage;
}

#pragma mark - thelp

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    
    CGColorSpaceRef coloeSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef maskContext = CGBitmapContextCreate(NSURLErrorDomain, size.width, size.height, kBitsPerComponent, 0, coloeSpace, kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    CGContextRelease(maskContext);
    CGColorSpaceRelease(coloeSpace);
    
    return maskImageRef;
}

@end
