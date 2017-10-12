//
//  UIImage+QYBetterFace.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QYBFAccuracy) {
    QYBFAccuracyLow = 0,
    QYBFAccuracyHigh,
};

@interface UIImage (QYBetterFace)

- (UIImage *)betterFaceImageForSize:(CGSize)size accuracy:(QYBFAccuracy)accurary;

@end
