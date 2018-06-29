//
//  QYTenViewController.m
//  MHRefresh
//
//  Created by panle on 2018/5/9.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYTenViewController.h"

@interface QYTenViewController ()

@property (nonatomic, strong) CALayer *colorLayer;

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UIImageView *ballView;

@end

@implementation QYTenViewController

//float quadraticEaseInOut(float t)
//{
//    return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
//}
//
//float bounceEaseOut(float t)
//{
//    if (t < 4/11.0) {
//        return (121 * t * t)/16.0;
//    } else if (t < 8/11.0) {
//        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
//    } else if (t < 9/10.0) {
//        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
//    }
//    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.view.backgroundColor = [UIColor whiteColor];
////    [self animationSpeed];
////    [self animationSpeedView];
////    [self keyFrameAnimation];
////    [self customANimation];
//
//    [self animation];
//}
//
//#pragma mark - ===== 流程自动化 =====
//
//- (float)interpolate:(float)from to:(float)to time:(float)time {
//    return (to - time) * time + from;
//}
//
//- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time {
//
//    if ([fromValue isKindOfClass:[NSValue class]]) {
//
//        const char *type = [fromValue objCType];
//
//        if (strcmp(type, @encode(CGPoint)) == 0) {
//            CGPoint from = [fromValue CGPointValue];
//            CGPoint to = [toValue CGPointValue];
//            CGPoint result = CGPointMake(from.x, [self interpolate:from.y to:to.y time:time]);
//            return [NSValue valueWithCGPoint:result];
//        }
//    }
//
//    return (time < 0.5) ? fromValue : toValue;
//}
//
//
//- (void)animation {
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [_ballView removeFromSuperview];
//
//        _ballView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//        _ballView.image = [UIImage imageNamed:@"ao1"];
//        _ballView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
//        [self.view addSubview:_ballView];
//
//        NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_W / 2.0, 150)];
//        NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_W / 2.0, 300)];
//
//        CFTimeInterval duration = 1.0;
//
//        NSInteger numFrames = duration * 60;
//        NSMutableArray *frames = [NSMutableArray array];
//
//        for (int i = 0; i < numFrames; i++) {
//            float time = 1 / (float)numFrames * i;
//            time = bounceEaseOut(time);
//            [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
//        }
//
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//        animation.keyPath = @"position";
//        animation.duration = 1.0;
//        animation.values = frames;
//
//        [_ballView.layer addAnimation:animation forKey:nil];
//
//        [self animation];
//    });
//}
//
//
//#pragma mark - ===== control =====
//
//- (void)customANimation {
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _colorView = [[UIView alloc] init];
//        _colorView.frame = CGRectMake(0, 0, 200, 200);
//        _colorView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
//        _colorView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_colorView];
//
//        CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
//        //get control points
//        CGPoint controlPoint1, controlPoint2;
//        [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
//        [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
//        //create curve
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path moveToPoint:CGPointZero];
//        [path addCurveToPoint:CGPointMake(1, 1)
//                controlPoint1:controlPoint1 controlPoint2:controlPoint2];
//        //scale the path up to a reasonable size for display
//        [path applyTransform:CGAffineTransformMakeScale(200, 200)];
//        //create shape layer
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        shapeLayer.strokeColor = [UIColor redColor].CGColor;
//        shapeLayer.fillColor = [UIColor clearColor].CGColor;
//        shapeLayer.lineWidth = 4.0f;
//        shapeLayer.path = path.CGPath;
//        [_colorView.layer addSublayer:shapeLayer];
//        //flip geometry so that 0,0 is in the bottom-left
//        _colorView.layer.geometryFlipped = YES;
//    });
//}
//
//#pragma mark - ===== 关键帧动画 =====
//
//- (void)keyFrameAnimation {
//
//    _colorView = [[UIView alloc] init];
//    _colorView.frame = CGRectMake(0, 0, 150, 150);
//    _colorView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
//    _colorView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_colorView];
//
//    _colorLayer = [CALayer layer];
//    _colorLayer.frame = CGRectMake(0, 0, 150, 150);
//    _colorLayer.backgroundColor = [UIColor blueColor].CGColor;
//    [_colorView.layer addSublayer:_colorLayer];
//
//    [self changeColor];
//}
//
//- (void)changeColor {
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//        animation.keyPath = @"backgroundColor";
//        animation.duration = 2.0;
//
//        animation.values = @[ (__bridge id)[UIColor blueColor].CGColor,
//                              (__bridge id)[UIColor redColor].CGColor,
//                              (__bridge id)[UIColor greenColor].CGColor,
//                              (__bridge id)[UIColor blueColor].CGColor
//                              ];
//
//        CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
////        animation.timingFunctions = @[fn, fn, fn];
//        animation.timingFunction = fn;
//        [_colorLayer addAnimation:animation forKey:nil];
//
//        [self changeColor];
//    });
//}
//
//#pragma mark - ===== UIView =====
//
//- (void)animationSpeedView {
//    //create a red layer
//    self.colorView = [[UIView alloc] init];
//    self.colorView.bounds = CGRectMake(0, 0, 100, 100);
//    self.colorView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
//    self.colorView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.colorView];
//}
//
//#pragma mark - ===== 动画速度 =====
//
//- (void)animationSpeed {
//    self.colorLayer = [CALayer layer];
//    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
//    self.colorLayer.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
//    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:self.colorLayer];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//
//    if (_colorView) {
//        //perform the animation
//        [UIView animateWithDuration:1.0 delay:0.0
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             //set the position
//                             self.colorView.center = [[touches anyObject] locationInView:self.view];
//                         }
//                         completion:NULL];
//    }
//
//    if (_colorLayer) {
//        //configure the transaction
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1.0];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//        //set the position
//        self.colorLayer.position = [[touches anyObject] locationInView:self.view];
//        //commit transaction
//        [CATransaction commit];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
