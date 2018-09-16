//
//  UIImage+UPData.m
//  Up
//
//  Created by panle on 2018/4/10.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIImage+UPData.h"
//#import "NSData+MImageContentType.h"
#import "UIImage+WebP.h"
#import "NSData+ImageContentType.h"

@implementation UIImage (UPData)

+ (instancetype)up_imageWithData:(NSData *)data {
    
    if (!data) {
        return nil;
    }
    
//    if ([NSData isWebpImage:data]) {
//        return [UIImage sd_imageWithWebPData:data];
//    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *resImage;
    
    if (count <= 1) {
        resImage = [[UIImage alloc] initWithData:data];
    } else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0;
        
        for (size_t i = 0; i < count; i ++) {
            
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            float element = 0.0;
            
            //NSDictionary *dict =  (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(sour, i, NULL);
            CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, i ,nil);
            NSDictionary *dict = (__bridge NSDictionary*)cfFrameProperties;
            NSDictionary *gifProperties = dict[(NSString *)kCGImagePropertyGIFDictionary];
            
            NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            if (delayTimeUnclampedProp) {
                element = [delayTimeUnclampedProp floatValue];
            }
            else {
                NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
                if (delayTimeProp) {
                    element = [delayTimeProp floatValue];
                }
            }
            
            if (element <= 0.011f) {
                element = 0.1;
            }
            
            duration += element;
            [images addObject:[UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CFRelease(cfFrameProperties);
            CFRelease(imageRef);
        }
        
        if (!duration) {
            duration = 1.0 / 10.0 * count;
        }
        
        resImage = [UIImage animatedImageWithImages:images duration:duration + 0.4]; // 领导要求加上 0.2s 的延迟
    }
    
    
    CFRelease(source);
    return resImage;
}

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength {
    
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    CGFloat compressionQuality = 1.0;
    while (data.length > maxLength) {
        compressionQuality -= 0.1;
        data = UIImageJPEGRepresentation(self, compressionQuality);
    }
    return data;
}

- (NSData *)data {
    return [self dataWithMaxLength:NSUIntegerMax];
}

- (UIImage *)imageWithLimitSize:(CGSize)size {
    
    UIImage *image = self;
    if (self.size.width > self.size.height) { // 宽长
        CGFloat x = (self.size.width - self.size.height) / 2;
        UIGraphicsBeginImageContext(CGSizeMake(self.size.height, self.size.height));
        [self drawAtPoint:CGPointMake(-x, 0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (self.size.width < self.size.height) {
        CGFloat y = (self.size.height - self.size.width) / 2;
        UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.width));
        [self drawAtPoint:CGPointMake(0, -y)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *finImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(finImage, 0.8);
    
    return [UIImage imageWithData:data];
}

@end
