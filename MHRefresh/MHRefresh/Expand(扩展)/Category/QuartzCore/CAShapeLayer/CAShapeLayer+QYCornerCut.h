//
//  CAShapeLayer+QYCornerCut.h
//  MHRefresh
//
//  Created by panle on 2018/8/3.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, QYCornerCutImageType) {
    QYCornerCutImageTypeDefault,
    QYCornerCutImageTypeLeftTop,
    QYCornerCutImageTypeRightTop,
    QYCornerCutImageTypeLeftBottom,
    QYCornerCutImageTypeRightBottom,
    QYCornerCutImageTypeTop,
    QYCornerCutImageTypeBottom
};

typedef NS_ENUM(NSInteger, UPCornerCuuType) {
    UPCornerCuuTypeDefault,
    UPCornerCuuTypeLeftTop,
    UPCornerCuuTypeRightTop,
    UPCornerCuuTypeLeftBottom,
    UPCornerCuuTypeRightBottom,
    UPCornerCuuTypeTop,
    UPCornerCuuTypeBottom
};

@interface CAShapeLayer (QYCornerCut)

@end
