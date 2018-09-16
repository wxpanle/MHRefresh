//
//  UIBezierPath+UPCircleCut.h
//  Up
//
//  Created by panle on 2018/8/3.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPBezierPathCircleCutType) {
    UPBezierPathCircleCutTypeDefault = 0,
    UPBezierPathCircleCutTypeLeft,
    UPBezierPathCircleCutTypeRight,
    UPBezierPathCircleCutTypeLeftTop,
    UPBezierPathCircleCutTypeRightTop,
    UPBezierPathCircleCutTypeLeftBottom,
    UPBezierPathCircleCutTypeRightBottom,
    UPBezierPathCircleCutTypeTop,
    UPBezierPathCircleCutTypeBottom
};

@interface UIBezierPath (UPCircleCut)

+ (UIBezierPath *)up_bezierPathWithType:(UPBezierPathCircleCutType)type
                                   size:(CGSize)size
                           cornerRadius:(CGFloat)cornerRadius;

@end
