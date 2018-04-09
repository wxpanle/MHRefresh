//
//  UIScreen+UPFrame.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIScreen+UPFrame.h"

@implementation UIScreen (UPFrame)

+ (CGSize)up_size {
    return [[self mainScreen] bounds].size;
}

+ (CGFloat)up_width {
    return [self up_size].width;
}

+ (CGFloat)up_height {
    return [self up_size].height;
}

+ (CGSize)up_orientationSize {
    BOOL isLand = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    return isLand ? SwapSize([self up_size]) : [self up_size];
}

+ (CGFloat)up_orientationWidth {
    return [self up_orientationSize].width;
}

+ (CGFloat)up_orientationHeight {
    return [self up_orientationSize].height;
}

+ (CGSize)up_DPISize {
    CGFloat scale = [self mainScreen].scale;
    return CGSizeMake([self up_width] * scale, [self up_height] * scale);
}

static inline CGSize SwapSize(CGSize size) {
    return CGSizeMake(size.height, size.width);
}

@end
