//
//  QYEightViewController.m
//  MHRefresh
//
//  Created by panle on 2018/5/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYEightViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface QYEightViewController () <CAAnimationDelegate>

@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) CALayer *shipLayer;

@end

@implementation QYEightViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self propertyAnimation];
//    [self keyFrameAnimation];
//    [self inventedproperty];
//    [self groupAnimation];
//    [self animationCustom];
    [self cancelAnimation];
}

#pragma mark - ===== 在动画过程中取消动画 =====

- (void)cancelAnimation {
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _containerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_containerView];
    
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 128, 128);
    self.shipLayer.position = CGPointMake(150, 150);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ao1"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    
    [self start];
}

- (void)start {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation";
        animation.duration = 3.0;
        animation.byValue = @(M_PI * 2);
        animation.delegate = self;
        [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stop];
        });
        
        [self start];
    });
}

- (void)stop {
    [self.shipLayer removeAnimationForKey:@"rotateAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    //log that the animation stopped
    NSLog(@"The animation stopped (finished: %@)", flag? @"YES": @"NO");
}

#pragma mark - ===== 过渡 自定义动画 =====

- (void)animationCustom {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"ao1"];
        _imageView.frame = CGRectMake(0, 0, 100, 100);
        _imageView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
        [self.view addSubview:_imageView];
        
        //    [self switchView];
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
        //insert snapshot view in front of this one
        UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
        coverView.frame = self.view.bounds;
        [self.view addSubview:coverView];
        //update the view (we'll simply randomize the layer background color)
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        //perform animation (anything you like)
        [UIView animateWithDuration:1.0 animations:^{
            //scale, rotate and fade the view
            CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            coverView.transform = transform;
            coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            //remove the cover view now we're finished with it
            [coverView removeFromSuperview];
            
            [self animationCustom];
        }];
    });


}

- (void)switchView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        static NSUInteger i = 0;
        UIViewAnimationOptions options = (UIViewAnimationOptions)(i << 20);
        
        i++;
        
        if (i >= 7) {
            i = 0;
        }
        
        [UIView transitionWithView:self.imageView duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            
        } completion:^(BOOL finished) {
            [self switchView];
        }];
    });
    
}

#pragma mark - ===== group =====

- (void)groupAnimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, 300)];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_containerView];
        
        //create a path
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:CGPointMake(0, 150)];
        [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
        
        //draw the path using a CAShapeLayer
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.path = bezierPath.CGPath;
        pathLayer.fillColor = [UIColor clearColor].CGColor;
        pathLayer.strokeColor = [UIColor redColor].CGColor;
        pathLayer.lineWidth = 3.0f;
        [self.containerView.layer addSublayer:pathLayer];
        
        //add a colored layer
        CALayer *colorLayer = [CALayer layer];
        colorLayer.frame = CGRectMake(0, 0, 64, 64);
        colorLayer.position = CGPointMake(0, 150);
        colorLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.containerView.layer addSublayer:colorLayer];
        
        //create the position animation
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
        animation1.keyPath = @"position";
        animation1.path = bezierPath.CGPath;
        animation1.rotationMode = kCAAnimationRotateAuto;
        
        //create the color animation
        CABasicAnimation *animation2 = [CABasicAnimation animation];
        animation2.keyPath = @"backgroundColor";
        animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
        
        //create group animation
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[animation1, animation2];
        groupAnimation.duration = 4.0;
        
        //add the animation to the color layer
        [colorLayer addAnimation:groupAnimation forKey:nil];
        
        [self groupAnimation];
    });
    
    
}

#pragma mark - ===== 属性动画 =====
- (void)propertyAnimation {
    
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50.0, 50.0, 100.0, 100.0);
    _colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_colorLayer];
    
    [self changeColor1];
}

- (void)changeColor {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //create a new random color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        //create a basic animation
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"backgroundColor";
        animation.toValue = (__bridge id)color.CGColor;
        animation.delegate = self;
        //apply animation to layer
        [self.colorLayer addAnimation:animation forKey:nil];
        
        [self changeColor];
    });
}

#pragma mark - ===== 虚拟属性 =====

- (void)inventedproperty {
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, 300)];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_containerView];
        
        //add the ship
        CALayer *shipLayer = [CALayer layer];
        shipLayer.frame = CGRectMake(0, 0, 128, 128);
        shipLayer.position = CGPointMake(150, 150);
        shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ao1"].CGImage;
        [self.containerView.layer addSublayer:shipLayer];
        //animate the ship rotation
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation";
        animation.duration = 2.0;
        animation.byValue = @(M_PI * 2);
        [shipLayer addAnimation:animation forKey:nil];
        
        [self inventedproperty];
    });
    

}

#pragma mark - ===== 关键帧动画 =====

- (void)keyFrameAnimation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, 300)];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_containerView];
        
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        [bezierPath moveToPoint:CGPointMake(0, 150)];
        [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
        
        //draw the path using a CAShapeLayer
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.path = bezierPath.CGPath;
        pathLayer.fillColor = [UIColor clearColor].CGColor;
        pathLayer.strokeColor = [UIColor redColor].CGColor;
        pathLayer.lineWidth = 3.0f;
        [self.containerView.layer addSublayer:pathLayer];
        
        //add the ship
        CALayer *shipLayer = [CALayer layer];
        shipLayer.frame = CGRectMake(0, 0, 64, 64);
        shipLayer.position = CGPointMake(0, 150);
        shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ao1"].CGImage;;
        [self.containerView.layer addSublayer:shipLayer];
        //create the keyframe animation
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.duration = 10.0;
        animation.path = bezierPath.CGPath;
        animation.rotationMode = kCAAnimationRotateAuto;
        [shipLayer addAnimation:animation forKey:nil];
        
        [self keyFrameAnimation];
    });
}

- (void)changeColor1 {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"backgroundColor";
        animation.duration = 2.0;
        animation.values = @[
                             (__bridge id)[UIColor blueColor].CGColor,
                             (__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor ];
        
        [self.colorLayer addAnimation:animation forKey:nil];
        
        [self changeColor1];
    });
}



/* Delegate methods for CAAnimation. */
#pragma mark - ===== CAAnimationDelegate =====

//- (void)animationDidStart:(CAAnimation *)anim {}
//
//- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
//    
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
//    [CATransaction commit];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
