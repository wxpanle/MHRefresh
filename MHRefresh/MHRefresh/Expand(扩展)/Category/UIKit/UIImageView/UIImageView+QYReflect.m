//
//  UIImageView+QYReflect.m
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIImageView+QYReflect.h"
#import "QYStaticInline.h"

@implementation UIImageView (QYReflect)

- (void)reflect {
    
    CGRect frame = self.frame;
    
    frame.origin.y += CGFloat_ceil(frame.size.height);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = YES;
    reflectionImageView.contentMode = self.contentMode;
    reflectionImageView.image = self.image;
    reflectionImageView.transform = self.transform;
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2.0, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,
                             (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0.5);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];
}

@end
