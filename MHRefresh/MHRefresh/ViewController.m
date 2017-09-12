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
#import <SDWebImage/SDWebImageDownloader.h>

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
    self.cardView = [[MPreviewCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.cardView reloadDataWithSuperView:self.view andCurrentIndex:10];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (IBAction)start:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://oiijtsooa.qnssl.com/732xr2YGaBjzVCFcPrfwp_QlOk2e9dVc1504843496329.jpeg"];
    WeakSelf
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        DLog(@"%ld %ld", (long)receivedSize, (long)expectedSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            DLog(@"%@", error.description);
        }
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = image;
            });
        }
    }];
    
//    WeakSelf
//    [MImagePickerController pickPictureWithPresentVc:self sourceType:MImagePickerSourceTypeDefault cropMode:MImagePickerCropModeCircle handleBlock:^(UIViewController *vc, UIImage *image) {
//        [vc dismissViewControllerAnimated:YES completion:nil];
//        weakSelf.imageView.image = image;
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
