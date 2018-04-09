//
//  yxconfig.h
//  Annotation
//
//  Created by zyx on 2017/4/28.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#ifndef yxconfig_h
#define yxconfig_h

typedef NS_ENUM(NSInteger, AnnotationType) {
    AnnotationTypeRectangle,
    AnnotationTypeRound,
};

#define M_WIDGHT [UIScreen mainScreen].bounds.size.width
#define M_HEIGHT [UIScreen mainScreen].bounds.size.height

#define A(number) (double) number / 255
//#define RANDOM  (double)arc4random_uniform(256) / 255
//#define RGB(r, g, b)  [UIColor colorWithRed:A(r) green:A(g) blue:A(b) alpha:1.0]
//#define RGBA(r, g, b, a)  [UIColor colorWithRed:A(r) green:A(g) blue:A(b) alpha:a]
#define RANDOMCOLOR [UIColor colorWithRed:RANDOM green:RANDOM blue:RANDOM alpha:1.0]


#define CGPointMakeOffset(origin, offset) CGPointMake(origin.x + offset.x, origin.y + offset.y)
#define CGPointGetOffset(point1, point2) CGPointMake(point2.x - point1.x, point2.y - point1.y)




#endif /* yxconfig_h */
