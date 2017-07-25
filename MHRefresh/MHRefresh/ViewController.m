//
//  ViewController.m
//  MHRefresh
//
//  Created by developer on 2017/7/25.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "ViewController.h"
#import "MPreviewCardView.h"

@interface ViewController ()

@property (nonatomic, strong) MPreviewCardView *cardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUIOfSelf];
    [self layoutUIOtherPreviewCardView];
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOtherPreviewCardView {
    self.cardView = [[MPreviewCardView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.cardView reloadDataWithSuperView:self.view andCurrentIndex:10];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
