//
//  UIImage+QYOrientation.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QYOrientation)

- (UIImage *)fixOrientation;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

- (UIImage *)flipVertical;

- (UIImage *)flipHorizontal;

@end
