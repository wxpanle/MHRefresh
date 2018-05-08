//
//  QYSenveViewController.m
//  MHRefresh
//
//  Created by panle on 2018/5/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYSenveViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface QYSenveViewController ()

@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation QYSenveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self transaction];
//    [self views];
    [self showAndModel];
}

#pragma mark - ===== 呈现与模型 =====

- (void)showAndModel {
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50.0, 50.0, 50.0, 50.0);
    _colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_colorLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

#pragma mark - ===== 图层行为 =====
- (void)views {
    _layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _layerView.backgroundColor = [UIColor whiteColor];
    _layerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    [self.view addSubview:_layerView];
    
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50.0, 50.0, 50.0, 50.0);
    _colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [_layerView.layer addSublayer:_colorLayer];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
    
    [self changeColor];
}

- (void)changeColor1 {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //begin a new transaction
        [CATransaction begin];
        //set the animation duration to 1 second
        [CATransaction setAnimationDuration:1.0];
        //randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        //commit the transaction
        [CATransaction commit];
        
        [self changeColor1];
    });
}

#pragma mark - ===== 事务 =====
- (void)transaction {
    
    _layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _layerView.backgroundColor = [UIColor whiteColor];
    _layerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    [self.view addSubview:_layerView];
    
    _colorLayer = [CALayer layer];
    _colorLayer.frame = CGRectMake(50.0, 50.0, 50.0, 50.0);
    _colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [_layerView.layer addSublayer:_colorLayer];
    
    [self transactionchangeColor];
}

- (void)changeColor {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        _colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        
        [self changeColor];
    });
}

- (void)transactionchangeColor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        
        //完成快
        [CATransaction setCompletionBlock:^{
            CGAffineTransform transform = self.colorLayer.affineTransform;
            transform = CGAffineTransformRotate(transform, M_PI_4);
            _colorLayer.affineTransform = transform;
        }];
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        _colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        [CATransaction commit];
        
        [self transactionchangeColor];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
