//
//  QYOnePointFive.m
//  MHRefresh
//
//  Created by panle on 2018/4/16.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYOnePointFive.h"

@interface QYOnePointFive ()

@property (nonatomic, strong) UIView *layerView;

@end

@implementation QYOnePointFive

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    _layerView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, SCREEN_W / 2.0, SCREEN_W / 2.0)];
    _layerView.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _layerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_layerView];
    
    CALayer *layer = [CALayer layer];
    
    layer.frame = CGRectMake(50.0, 50.0, 100.0, 100.0);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    
    [self.layerView.layer addSublayer:layer];
    
}

@end
