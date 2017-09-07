//
//  ViewController.m
//  MHRefresh
//
//  Created by developer on 2017/7/25.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "ViewController.h"
#import "MPreviewCardView.h"
#import "MImagePickerController.h"

@interface ViewController ()

@property (nonatomic, strong) MPreviewCardView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUIOfSelf];
//    [self layoutUIOtherPreviewCardView];
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOtherPreviewCardView {
    self.cardView = [[MPreviewCardView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.cardView reloadDataWithSuperView:self.view andCurrentIndex:10];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (IBAction)start:(UIButton *)sender {
    MemoryWeakSelf
    [MImagePickerController pickPictureWithPresentVc:self sourceType:MImagePickerSourceTypeDefault cropMode:MImagePickerCropModeCircle handleBlock:^(UIViewController *vc, UIImage *image) {
        [vc dismissViewControllerAnimated:YES completion:nil];
        weakSelf.imageView.image = image;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
