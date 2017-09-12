//
//  UIView+QYVisuals.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

///------------------------------------------------
/// @name https://github.com/bfolder/UIView-Visuals
///------------------------------------------------

#import <UIKit/UIKit.h>

@interface UIView (QYVisuals)

- (void)cornerRadius:(CGFloat)radius
         strokeWidth:(CGFloat)width
               color:(UIColor *)color;

- (void)setRoundedCorners:(UIRectCorner)corners
                   radius:(CGFloat)radius;

- (void)shadowWithColor:(UIColor *)color
                 offset:(CGSize)offset
                opacity:(CGFloat)opacity
                 radius:(CGFloat)radius;

- (void)removeFromSuperviewWithFadeDuration:(NSTimeInterval)duration;

- (void)addSubview:(UIView *)view
    withTransition:(UIViewAnimationTransition)transition
          duration:(NSTimeInterval)duration;

- (void)removeFromSuperviewWithTransition:(UIViewAnimationTransition)transition
                                 duration:(NSTimeInterval)duration;

- (void)rotateByAngle:(CGFloat)angle
             duration:(NSTimeInterval)duration
          autoreverse:(BOOL)autoreverse
          repeatCount:(CGFloat)repeatCount
       timingFunction:(CAMediaTimingFunction *)timingFunction;

- (void)moveToPoint:(CGPoint)newPoint
           duration:(NSTimeInterval)duration
        autoreverse:(BOOL)autoreverse
        repeatCount:(CGFloat)repeatCount
     timingFunction:(CAMediaTimingFunction *)timingFunction;

@end
