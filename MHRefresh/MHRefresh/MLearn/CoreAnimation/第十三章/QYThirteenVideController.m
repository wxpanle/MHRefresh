//
//  QYThirteenVideController.m
//  MHRefresh
//
//  Created by panle on 2018/6/4.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYThirteenVideController.h"
#import "QYVectorPicture.h"

@interface QYThirteenVideController ()

@end

@implementation QYThirteenVideController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self vectorPicture];
}

#pragma mark - ===== 矢量图形 =====

- (void)vectorPicture {
    
    QYVectorPicture *view = [[QYVectorPicture alloc] initWithFrame:self.view.bounds];
    view.userInteractionEnabled = YES;
    
    [self.view addSubview:view];
}


@end
