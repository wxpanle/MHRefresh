//
//  QYCoreAnimationModel.m
//  MHRefresh
//
//  Created by panle on 2018/4/16.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYCoreAnimationModel.h"

#import "QYOnePointFive.h"
#import "QYTwoPointOneController.h"
#import "QYThreeViewController.h"
#import "QYSixViewController.h"
#import "QYSenveViewController.h"
#import "QYEightViewController.h"

@implementation QYCoreAnimationModel

+ (void)testWithVc:(UIViewController *)vc {
    [self p_oneVc:vc];
}

+ (void)p_oneVc:(UIViewController *)vc {
    
//    QYOnePointFive *vc1 = [[QYOnePointFive alloc] init];
//    QYTwoPointOneController *vc1 = [[QYTwoPointOneController alloc] init];
//    QYThreeViewController *vc1 = [[QYThreeViewController alloc] init];
//    QYSixViewController *vc1 = [[QYSixViewController alloc] init];
//    QYSenveViewController *vc1 = [[QYSenveViewController alloc] init];
    QYEightViewController *vc1 = [[QYEightViewController alloc] init];
    
    [self vc:vc vc1:vc1];
}

+ (void)vc:(UIViewController *)vc vc1:(UIViewController *)vc1 {
    [vc presentViewController:vc1 animated:YES completion:nil];
}

@end
