//
//  UIScreen+UPFrame.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (UPFrame)

+ (CGSize)up_size;
+ (CGFloat)up_width;
+ (CGFloat)up_height;

+ (CGSize)up_orientationSize;
+ (CGFloat)up_orientationWidth;
+ (CGFloat)up_orientationHeight;
+ (CGSize)up_DPISize;

@end
