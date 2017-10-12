//
//  UIImage+QYColor.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QYColor)

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIColor *)colorAtPoint:(CGPoint )point;

- (UIColor *)colorAtPixel:(CGPoint)point;

+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

@end
