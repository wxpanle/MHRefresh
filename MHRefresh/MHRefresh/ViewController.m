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
//#import "SDWebImageDownloader.h"
#import "QYPreviewViewController.h"
#import "NSString+QYEmoji.h"

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
    [self layoutUIOfSelf];
    [self addImage];
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOtherPreviewCardView {
    self.cardView = [[MPreviewCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.cardView reloadDataWithSuperView:self.view andCurrentIndex:10];
}

- (void)addImage {
    
    NSInteger width = (SCREEN_W - 10 * 4) / 3.0;
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        UIImage *image = [UIImage imageNamed:[self.dataArray objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = image;
        
        NSInteger x = i / 3;
        NSInteger y = i % 3;
        
        imageView.frame = CGRectMake(10 + y * (10 + width), 50 + x * (10 + width), width, width);
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPreview:)];
        [imageView addGestureRecognizer:tap];
        
        [self.view addSubview:imageView];
        [self.imageViewArray addObject:imageView];
    }
}

- (void)startPreview:(UITapGestureRecognizer *)tap {
    self.number = tap.view.tag;
    [QYPreviewViewController previewWithDelegate:self dataSource:self];
}

- (IBAction)start:(UIButton *)sender {
    
//    NSURL *url = [NSURL URLWithString:@"http://oozt9b874.bkt.clouddn.com/p2466821152.webp"];
//    WeakSelf
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        DLog(@"%ld %ld", (long)receivedSize, (long)expectedSize);
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if (error) {
//            DLog(@"%@", error.description);
//        }
//
//        if (image) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.imageView.image = image;
//            });
//        }
//    }];
    
    
//    [MImagePickerController pickPictureWithPresentVc:self sourceType:MImagePickerSourceTypeDefault cropMode:MImagePickerCropModeCircle handleBlock:^(UIViewController *vc, UIImage *image) {
//        [vc dismissViewControllerAnimated:YES completion:nil];
//        self.imageView.image = image;
//    }];
    
    NSString *string = @"😄:smile 😆::laughing:D  😊 blush  😨 fearful 👿 imp 💙 blue_heart 🌟 star ❓question 💦 sweat_drops  ✊ fist  👪 family 🙆 ok_woman  👹 japanese_ogre 👀 eyes 🌀 cyclone  🍁 maple_leaf  🌖 waning_gibbous_moon  🔍 mag 🚚 truck 🕔 clock5 🆒 cool ㊗ congratulations ㊙ secret ❌ x  ㊙ ㊗";
    
    DLog(@"%@", [NSString replaceEmojiWithText:string replaceText:@"中国"]);
    DLog(@"%@", [NSString replaceEmojiWithText:string replaceText:@"?"]);
    DLog(@"%@", [string clearEmoji]);
}


- (nullable UIImage *)previewStartImage:(NSInteger)index {
    return [UIImage imageNamed:[self.dataArray objectAtIndex:index]];
}

- (nullable UIView *)previewAnimationView:(NSInteger)index {
    return [self.imageViewArray objectAtIndex:index];
}

- (void)previewWillStart:(NSInteger)index {
    
//    for (UIImageView *imageView in self.imageViewArray) {
//        imageView.hidden = NO;
//    }
//
//    UIImageView *imageView = [self.imageViewArray objectAtIndex:index];
//    imageView.hidden = YES;
}

- (void)previewWillEnd:(NSInteger)index {
//    for (UIImageView *imageView in self.imageViewArray) {
//        imageView.hidden = NO;
//    }
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
