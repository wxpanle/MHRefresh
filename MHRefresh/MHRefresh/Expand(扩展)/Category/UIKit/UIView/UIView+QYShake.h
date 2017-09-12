//
//  UIView+QYShake.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

///----------------------------------------------------
/// @name https://github.com/andreamazz/UIView-Shake
///----------------------------------------------------

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYShakeDirection) {
    QYShakeDirectionHorizontal,
    QYShakeDirectionVertical
};

typedef void (^ QYShakeCompleteBlock) ();

@interface UIView (QYShake)

- (void)shake;

- (void)shake:(int)times withDelta:(CGFloat)delta;

- (void)shake:(int)times withDelta:(CGFloat)delta completion:(QYShakeCompleteBlock)handler;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)()))handler;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(QYShakeDirection)shakeDirection;

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(QYShakeDirection)shakeDirection completion:(QYShakeCompleteBlock)handle;


@end
