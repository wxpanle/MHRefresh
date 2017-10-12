//
//  UIImage+QYCapture.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QYCapture)

+ (UIImage *)captureWithView:(UIView *)view;

+ (UIImage *)getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *)bigImage;

+ (UIImage *)screenshotWithView:(UIView *)aView limitWidth:(CGFloat)maxWidth;

@end
