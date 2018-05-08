//
//  QYThreeViewController.m
//  MHRefresh
//
//  Created by panle on 2018/4/19.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYThreeViewController.h"

@interface QYThreeViewController ()

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIView *view2;

@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIView *view4;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QYThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];

    [self one];
}

- (void)one {
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0, SCREEN_W / 2.0)];
    _view1.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _view1.backgroundColor = [UIColor whiteColor];
    _view1.layer.cornerRadius = SCREEN_W / 2.0 / 2.0;
    _view1.clipsToBounds = YES;
    _view1.layer.borderWidth = 1.0;
    _view1.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_view1];
    
    
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0 / 2.0, 4.0)];
    _view2.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _view2.backgroundColor = [UIColor whiteColor];
    _view2.clipsToBounds = YES;
    _view2.layer.borderWidth = 1.0;
    _view2.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:_view2];
    
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0 / 2.0, 3.0)];
    _view3.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _view3.backgroundColor = [UIColor whiteColor];
    _view3.clipsToBounds = YES;
    _view3.layer.borderWidth = 1.0;
    _view3.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:_view3];
    
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W / 2.0 / 2.0, 2.0)];
    _view4.center = CGPointMake(SCREEN_W / 2.0, SCREEN_H / 2.0);
    _view4.backgroundColor = [UIColor whiteColor];
    _view4.clipsToBounds = YES;
    _view4.layer.borderWidth = 1.0;
    _view4.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:_view4];
    
    _view2.layer.anchorPoint = CGPointMake(0.2, 0.2);
    _view3.layer.anchorPoint = CGPointMake(0.2, 0.2);
    _view4.layer.anchorPoint = CGPointMake(0.2, 0.2);
    
    _view2.layer.zPosition = 1.0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *compoenets = [calendar components:units fromDate:[NSDate date]];
        
        CGFloat hoursAngle = (compoenets.hour / 12.0) * M_PI * 2.0 - M_PI_2;
        CGFloat minuteAngle = (compoenets.minute / 60.0) * M_PI * 2.0 - M_PI_2;
        CGFloat secAngle = (compoenets.second / 60.0) * M_PI * 2.0 - M_PI_2;
        
        NSLog(@"%ld, %ld, %ld", compoenets.hour, compoenets.minute, compoenets.second);
        
        _view2.transform = CGAffineTransformMakeRotation(hoursAngle);
        _view3.transform = CGAffineTransformMakeRotation(minuteAngle);
        _view4.transform = CGAffineTransformMakeRotation(secAngle);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
