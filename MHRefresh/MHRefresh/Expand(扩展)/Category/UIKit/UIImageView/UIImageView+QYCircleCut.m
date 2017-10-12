//
//  UIImageView+QYCircleCut.m
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIImageView+QYCircleCut.h"

@implementation UIImageView (QYCircleCut)

- (UIImage *)circleCutImage:(UIImage *)image {
    
    if (!image) return nil;
    
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.layer.cornerRadius, self.layer.cornerRadius)];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    [image drawInRect:[self getImageFitDrawRect:image withContentMode:self.contentMode]];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cornerCutImage:(UIImage *)image andCornerRadius:(CGFloat)cornerRadius andMode:(QYCornerCutImageType)cornerCutImageType {
    
    if (!image) return nil;
    
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = nil;
    
    switch (cornerCutImageType) {
        case QYCornerCutImageTypeDefault:{
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case QYCornerCutImageTypeTop:{
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case QYCornerCutImageTypeBottom:{
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case QYCornerCutImageTypeLeftTop:{
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case QYCornerCutImageTypeLeftBottom:{
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case QYCornerCutImageTypeRightTop:{
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case QYCornerCutImageTypeRightBottom: {
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        default: {
            path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
    }
    
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    [image drawInRect:[self getImageFitDrawRect:image withContentMode:self.contentMode]];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

/** 根据内容模式 获取Img渲染区间 */
- (CGRect)getImageFitDrawRect:(UIImage *)image withContentMode:(UIViewContentMode)mode{
    CGSize size    = image.size;
    if (mode == UIViewContentModeScaleToFill)
        return self.bounds;
    CGFloat scale = 1;
    if (mode == UIViewContentModeCenter) {
        scale = 1;
    }
    
    if (mode == UIViewContentModeScaleAspectFill) {
        scale = MIN(size.width/CGRectGetWidth(self.frame), size.height / CGRectGetHeight(self.frame));
    }
    
    
    if (mode == UIViewContentModeScaleAspectFit) {
        scale = MAX(size.width/CGRectGetWidth(self.frame), size.height / CGRectGetHeight(self.frame));
    }
    
    CGFloat W = size.width / scale, H = size.height / scale;
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - W / 2, CGRectGetHeight(self.frame) / 2 - H / 2, W, H);
    
    return frame;
}


@end
