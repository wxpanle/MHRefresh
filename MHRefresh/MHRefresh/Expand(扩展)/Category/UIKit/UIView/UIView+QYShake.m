//
//  UIView+QYShake.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIView+QYShake.h"

@implementation UIView (QYShake)

- (void)shake {
    [self shake:10 withDelta:5];
}

- (void)shake:(int)times withDelta:(CGFloat)delta {
    [self shake:times withDelta:delta speed:0.03];
}

- (void)shake:(int)times withDelta:(CGFloat)delta completion:(QYShakeCompleteBlock)handler {
    [self shake:times withDelta:delta speed:0.03 completion:handler];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self shake:times withDelta:delta speed:interval completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(QYShakeCompleteBlock)handler {
    [self shake:times withDelta:delta speed:interval shakeDirection:QYShakeDirectionHorizontal completion:handler];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(QYShakeDirection)shakeDirection {
    [self shake:times withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(QYShakeDirection)shakeDirection completion:(QYShakeCompleteBlock)handle {
    [self shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:handle];
}

- (void)shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(QYShakeDirection)shakeDirection completion:(QYShakeCompleteBlock)handle {
    [UIView animateWithDuration:interval animations:^{
        self.layer.affineTransform = (shakeDirection == QYShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                if (handle != nil) {
                    handle();
                }
            }];
            return;
        }
        [self shake:(times - 1)
           direction:direction * -1
        currentTimes:current + 1
           withDelta:delta
               speed:interval
      shakeDirection:shakeDirection
          completion:handle];
    }];
}


@end
