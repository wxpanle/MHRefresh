//
//  UIImage+QYGif.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QYGif)

+ (nullable UIImage *)animatedGIFWithData:(nullable NSData *)data;

+ (nullable UIImage *)animatedGIFNamed:(NSString *)name;

- (UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
