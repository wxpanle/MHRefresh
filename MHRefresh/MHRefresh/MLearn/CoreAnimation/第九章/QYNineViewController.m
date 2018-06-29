//
//  QYNineViewController.m
//  MHRefresh
//
//  Created by panle on 2018/5/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYNineViewController.h"

@interface QYNineViewController () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CALayer *shipLayer;
@property (nonatomic, strong) CALayer *doorLayer;

@end

@implementation QYNineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self durationAndRepeatCount];
    
    [self custom];
}

#pragma mark - ===== 手动动画 =====

- (void)custom {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _containerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
        _containerView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_containerView];
        
        //add the door
        self.doorLayer = [CALayer layer];
        self.doorLayer.frame = CGRectMake(0, 0, 200, 200);
        self.doorLayer.position = CGPointMake(100, 100);
        self.doorLayer.anchorPoint = CGPointMake(0.5, 0.5);
        self.doorLayer.contents = (__bridge id)[UIImage imageNamed:@"ao1"].CGImage;
        [self.containerView.layer addSublayer:self.doorLayer];
        //apply perspective transform
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        self.containerView.layer.sublayerTransform = perspective;
        //add pan gesture recognizer to handle swipes
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        [pan addTarget:self action:@selector(pan:)];
        [self.view addGestureRecognizer:pan];
        //pause all layer animations
        self.doorLayer.speed = 0.0;
        //apply swinging animation (which won't play because layer is paused)
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.rotation.y";
        animation.toValue = @(-M_PI_2);
        animation.duration = 1.0;
        [self.doorLayer addAnimation:animation forKey:nil];
    });
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    //get horizontal component of pan gesture
    CGFloat x = [pan translationInView:self.view].x;
    //convert from points to animation duration //using a reasonable scale factor
    x /= 200.0f;
    //update timeOffset and clamp result
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    //reset pan gesture
    [pan setTranslation:CGPointZero inView:self.view];
}

#pragma mark - ===== 持续和重复 =====

- (void)durationAndRepeatCount {
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _containerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_containerView];
    
    //add the ship
    self.shipLayer = [CALayer layer];
    self.shipLayer.frame = CGRectMake(0, 0, 150, 150);
    self.shipLayer.position = CGPointMake(100, 100);
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed: @"ao1"].CGImage;
    [self.containerView.layer addSublayer:self.shipLayer];
    
    [self animation];
}

- (void)animation {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static CFTimeInterval duration = 0;
        static float repeatCount = 0;
        
        static int i = 0;
        
        if (i % 2 == 0) {
            duration++;
        } else {
            repeatCount++;
        }
        
        
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.duration = duration;
        animation.repeatCount = repeatCount;
        animation.keyPath = @"transform.rotation";
        animation.byValue = @(M_PI * 2.0);
        animation.delegate = self;
        [_shipLayer addAnimation:animation forKey:nil];
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self animation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
