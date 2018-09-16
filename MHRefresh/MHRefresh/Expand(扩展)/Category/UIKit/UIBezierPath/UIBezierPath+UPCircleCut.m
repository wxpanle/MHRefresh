//
//  UIBezierPath+UPCircleCut.m
//  Up
//
//  Created by panle on 2018/8/3.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIBezierPath+UPCircleCut.h"

@implementation UIBezierPath (UPCircleCut)

+ (UIBezierPath *)up_bezierPathWithType:(UPBezierPathCircleCutType)type
                                   size:(CGSize)size
                           cornerRadius:(CGFloat)cornerRadius {
    
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    
    switch (type) {
        case UPBezierPathCircleCutTypeDefault: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeLeft: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeRight: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeTop: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeBottom: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeLeftTop: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeLeftBottom: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeRightTop: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
            
        case UPBezierPathCircleCutTypeRightBottom: {
            return [self bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        }
            break;
    }
}

@end
