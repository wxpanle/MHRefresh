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
#import "QYPreviewViewController.h"
#import "NSString+QYEmoji.h"
#import "Arithmetis.h"
#import <StoreKit/StoreKit.h>
#import "MWebView.h"

@interface ViewController () <QYPreviewViewControllerDelegate, QYPreviewViewControllerDataSource>

@property (nonatomic, strong) MPreviewCardView *cardView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) NSInteger number;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self layoutUIOfSelf];
    [self arithmeti];
//    [self addImage];

}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOtherPreviewCardView {
    self.cardView = [[MPreviewCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.cardView reloadDataWithSuperView:self.view andCurrentIndex:10];
}

- (void)addImage {
    
//    NSInteger width = (SCREEN_W - 10 * 4) / 3.0;
//
//    for (NSInteger i = 0; i < self.dataArray.count; i++) {
//        UIImage *image = [UIImage imageNamed:[self.dataArray objectAtIndex:i]];
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = image;
//
//        NSInteger x = i / 3;
//        NSInteger y = i % 3;
//
//        imageView.frame = CGRectMake(10 + y * (10 + width), 50 + x * (10 + width), width, width);
//
//        imageView.userInteractionEnabled = YES;
//        imageView.tag = i;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPreview:)];
//        [imageView addGestureRecognizer:tap];
//
//        [self.view addSubview:imageView];
//        [self.imageViewArray addObject:imageView];
//    }
}

- (void)arithmeti {
    [ChessResultModel getChessResult];
    [[[CakeSortModel alloc] initWithCakeArray:nil] sort];
}

- (void)startPreview:(UITapGestureRecognizer *)tap {
    self.number = tap.view.tag;
    [QYPreviewViewController previewWithDelegate:self dataSource:self];
}

- (IBAction)start:(UIButton *)sender {
    
    [SKStoreReviewController requestReview];
    
//    NSString *string = @"😄:smile 😆::laughing:D  😊 blush  😨 fearful 👿 imp 💙 blue_heart 🌟 star ❓question 💦 sweat_drops  ✊ fist  👪 family 🙆 ok_woman  👹 japanese_ogre 👀 eyes 🌀 cyclone  🍁 maple_leaf  🌖 waning_gibbous_moon  🔍 mag 🚚 truck 🕔 clock5 🆒 cool ㊗ congratulations ㊙ secret ❌ x  ㊙ ㊗";
//
//    DLog(@"%@", [NSString replaceEmojiWithText:string replaceText:@"中国"]);
//    DLog(@"%@", [NSString replaceEmojiWithText:string replaceText:@"?"]);
//    DLog(@"%@", [string clearEmoji]);
}


- (nullable UIImage *)previewStartImage:(NSInteger)index {
    return [UIImage imageNamed:[self.dataArray objectAtIndex:index]];
}

- (nullable UIView *)previewAnimationView:(NSInteger)index {
    return [self.imageViewArray objectAtIndex:index];
}

- (void)previewWillStart:(NSInteger)index {
    
}

- (void)previewWillEnd:(NSInteger)index {

}

- (NSInteger)previewDataSourceNumber {
    return self.dataArray.count;
}

- (UIImage *)previewImageWithIndex:(NSInteger)index {
    return [UIImage imageNamed:[self.dataArray objectAtIndex:index]];
}

- (NSString *)previewImageUrlStringWithIndex:(NSInteger)index {
    return [self.dataArray objectAtIndex:index];
}

- (NSInteger)currentIndex {
    return self.number;
}

- (NSMutableArray *)dataArray {
    
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"image_1.jpg"];
        [_dataArray addObject:@"image_2.jpg"];
        [_dataArray addObject:@"image_3.jpg"];
        [_dataArray addObject:@"image_4.jpg"];
        [_dataArray addObject:@"image_5.jpg"];
        [_dataArray addObject:@"image_6.jpg"];
        [_dataArray addObject:@"image_7.jpg"];
        [_dataArray addObject:@"image_8.jpg"];
        [_dataArray addObject:@"image_9.jpg"];
        [_dataArray addObject:@"image_10.jpg"];
    }
    return _dataArray;
}

- (NSMutableArray *)imageViewArray {
    if (nil == _imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
