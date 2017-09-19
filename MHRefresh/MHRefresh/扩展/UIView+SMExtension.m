//
//  UIView+SMExtension.m
//  SeeMovies
//
//  Created by developer on 2017/8/17.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "UIView+SMExtension.h"

@implementation UIView (SMExtension)

- (void)setSm_x:(CGFloat)sm_x {
    CGRect frame = self.frame;
    frame.origin.x = sm_x;
    self.frame = frame;
}

- (CGFloat)sm_x {
    return self.frame.origin.x;
}

- (void)setSm_y:(CGFloat)sm_y {
    CGRect frame = self.frame;
    frame.origin.y = sm_y;
    self.frame = frame;
}

- (CGFloat)sm_y {
    return self.frame.origin.y;
}

- (void)setSm_width:(CGFloat)sm_width {
    CGRect frame = self.frame;
    frame.size.width = sm_width;
    self.frame = frame;
}

- (CGFloat)sm_width {
    return self.frame.size.width;
}

- (void)setSm_height:(CGFloat)sm_height {
    CGRect frame = self.frame;
    frame.size.height = sm_height;
    self.frame = frame;
}

- (CGFloat)sm_height {
    return self.frame.size.height;
}

- (void)setSm_size:(CGSize)sm_size {
    CGRect frame = self.frame;
    frame.size = sm_size;
    self.frame = frame;
}

- (CGSize)sm_size {
    return self.frame.size;
}

- (void)setSm_centerX:(CGFloat)sm_centerX {
    CGPoint center = self.center;
    center.x = sm_centerX;
    self.center = center;
}

- (CGFloat)sm_centerX {
    return self.center.x;
}

- (void)setSm_centerY:(CGFloat)sm_centerY {
    CGPoint center = self.center;
    center.y = sm_centerY;
    self.center = center;
}

- (CGFloat)sm_centerY {
    return self.center.y;
}

- (void)setSm_origin:(CGPoint)sm_origin {
    CGRect frame = self.frame;
    frame.origin = sm_origin;
    self.frame = frame;
}

- (CGPoint)sm_origin {
    return self.frame.origin;
}


@end
