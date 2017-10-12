//
//  UIImageView+QYCircleCut.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYCornerCutImageType) {
    QYCornerCutImageTypeDefault,
    QYCornerCutImageTypeLeftTop,
    QYCornerCutImageTypeRightTop,
    QYCornerCutImageTypeLeftBottom,
    QYCornerCutImageTypeRightBottom,
    QYCornerCutImageTypeTop,
    QYCornerCutImageTypeBottom
};

@interface UIImageView (QYCircleCut)

- (UIImage *)circleCutImage:(UIImage *)image;

- (UIImage *)cornerCutImage:(UIImage *)image andCornerRadius:(CGFloat)cornerRadius andMode:(QYCornerCutImageType)cornerCutImageType;

@end
