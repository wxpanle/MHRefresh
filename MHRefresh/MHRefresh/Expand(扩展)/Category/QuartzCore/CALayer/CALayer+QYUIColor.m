//
//  CALayer+QYUIColor.m
//  MHRefresh
//
//  Created by panle on 2018/8/3.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "CALayer+QYUIColor.h"

@implementation CALayer (QYUIColor)

- (void)qy_setBorderColor:(UIColor *)borderColor {
    self.borderColor = borderColor.CGColor;
}

- (void)qy_setContentsWithImage:(UIImage *)image {
    self.contents = (__bridge id)(image.CGImage);
}

@end
