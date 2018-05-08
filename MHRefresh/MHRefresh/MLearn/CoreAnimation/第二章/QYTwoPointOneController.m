//
//  QYTwoPointOneController.m
//  MHRefresh
//
//  Created by panle on 2018/4/17.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYTwoPointOneController.h"

@interface QYTwoPointOneController () <CALayerDelegate>

@property (nonatomic, strong) UIView *layerView;

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIView *view2;

@end

@implementation QYTwoPointOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
//    _layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0, SCREEN_W / 2.0)];
//    _layerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
//    _layerView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_layerView];
//
//    UIImage *image = [UIImage imageNamed:@"test"];
//    _layerView.layer.contents = (__bridge id)image.CGImage;
    
//    _layerView.contentMode = UIViewContentModeScaleAspectFit;
    _layerView.layer.contentsGravity = kCAGravityResizeAspect;
    
    
//    _layerView.layer.contentsGravity = kCAGravityCenter;
//    _layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
//    _layerView.layer.masksToBounds = YES;
    
//    _layerView.layer.contentsRect = CGRectMake(0.25, 0.25, 0.5, 0.5);
//    _layerView.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
    
//    [self contentsCenter];
    
    [self layeDelegeter];
}

- (void)contentsCenter {
    
    
    UIImage * image = [UIImage imageNamed:@"test"];
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0, SCREEN_W / 2.0)];
    _view1.center = CGPointMake(SCREEN_W / 2.0, SCREEN_W / 2.0);
    _view1.backgroundColor = [UIColor clearColor];
    _view1.layer.masksToBounds = YES;
    [self.view addSubview:_view1];

    _view1.layer.contents = (__bridge id)image.CGImage;
    
    
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0, SCREEN_W / 2.0)];
    _view2.center = CGPointMake(SCREEN_W / 2.0 , SCREEN_W / 2.0 + SCREEN_W / 2.0 + 50);
    _view2.backgroundColor = [UIColor clearColor];
    _view2.layer.masksToBounds = YES;
    [self.view addSubview:_view2];
    
    _view2.layer.contents = (__bridge id)image.CGImage;
    _view2.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
    
    
//    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0, SCREEN_W / 2.0)];
//    _view2.center = CGPointMake(SCREEN_W / 2.0, SCREEN_W / 2.0);
//    _view2.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:_view2];
//
////    _view2.layer.contents = (__bridge id)image.CGImage;
//
//    _view2.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
}

- (void)layeDelegeter {
    _layerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0, SCREEN_W / 2.0)];
    _layerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_layerView];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0, 50.0, 100.0, 100.0);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [_layerView.layer addSublayer:blueLayer];
    
    [blueLayer display];
}

- (void)displayLayer:(CALayer *)layer {
    UIImage * image = [UIImage imageNamed:@"test"];
    layer.contents = (__bridge id)image.CGImage;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    CGContextSetLineWidth(ctx, 10.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
