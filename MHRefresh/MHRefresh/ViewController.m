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
#import <StoreKit/StoreKit.h>
#import "MWebView.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import <AVFoundation/AVFoundation.h>

#if __has_include(<SDWebImage/SDWebImageDownloader.h>)
#import <SDWebImage/SDWebImageDownloader.h>
#else
#import "SDWebImageDownloader.h"
#endif

#import "MNetworkAgent.h"
#import "MNetworkDownloadRequest.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#import <AssertMacros.h>

#import "MLearnHeader.h"

#import "QYMultiSelectViewController.h"

#import "QYAudioPlayer.h"

#import "PLAudioPlayer.h"
#import "QYPlayerTest.h"

#import "FMDB.h"

#import "NBPhoneNumberUtil.h"
#import "NBMetadataHelper.h"
#import "NBPhoneNumber.h"

#import "QYTestSearchViewController.h"

#import "QYNightHeader.h"

#import <WebKit/WebKit.h>

#import "QYPhotoBrowser.h"

#import "UPBaseTableView.h"
#import "UPPackageCell.h"

#import "UPEventLabel.h"

#import "QYCenterRefreshController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UPBaseSliderCellDelegate> {
    PLAudioPlayer *_audioPlayer;
    QYAudioPlayer *_qy_audio_player;
    FMDatabaseQueue *_dataSerialQueue;
}

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UPBaseTableView *tableView;

@property (nonatomic, strong) MPreviewCardView *cardView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImageView *tempImageView;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) QYPhotoBrowser *testView1;

@property (nonatomic, strong) dispatch_queue_t barrierQueue;

@property (nonatomic, strong) NSMutableArray *resultArray;

@end

typedef void (^blk_t)(id obj);

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//
//    QYCenterRefreshController *vc = [[QYCenterRefreshController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)test {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DLog(@"%@", NSStringFromCGSize([[UIScreen mainScreen] currentMode].size));
        [self test];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resultArray = [@[@"1", @"2", @"3"] mutableCopy];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [@"1" isEqualToString:evaluatedObject];
    }];
    
    DLog(@"%@", _resultArray);
    
    [_resultArray filterUsingPredicate:predicate];
    
    DLog(@"%@", _resultArray);
    
    
    NSArray *array = @[@"1", @"2", @"3"];
    DLog(@"%@", array);
    array = [array filteredArrayUsingPredicate:predicate];
    DLog(@"%@", array);
//    [self test];
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 200, SCREEN_W - 30, 0)];
//    textView.layer.borderColor = [UIColor redColor].CGColor;
//    textView.font = [UIFont fontPingFang:(QYPingFangSCRegular) size:16.0];
//    textView.layer.borderWidth = 1.0;
//    textView.clipsToBounds = YES;
////    textView.contentInset = UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0);
//    textView.textContainerInset = UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0);
////    textView.scrollEnabled = NO;
//    textView.showsVerticalScrollIndicator = NO;
//    textView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:textView];
//    
//    NSString *string = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
//    CGFloat height = [string heightWithFont:[UIFont fontPingFang:(QYPingFangSCRegular) size:16.0] constrainedToWidth:SCREEN_W - 60.0 numberLines:3];
//    textView.sm_height = height + 16.0;
//    
//    textView.text = string;
    
//    NSString *string = @"这是一个测试这是一个测试这是一个测试这是一是一个测试这是";
//
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontPingFang:QYPingFangSCRegular size:15.0],
//                                 NSParagraphStyleAttributeName: paragraph,
//                                 };
//
//    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:string attributes:attributes];
//
//    CGSize size = [UPEventLabel sizeThatFitsAttributedString:string1 withConstraints:CGSizeMake(SCREEN_W - 30, CGFLOAT_MAX) limitedToNumberOfLines:3];
//
//    CGFloat height = [string heightWithFont:[UIFont fontPingFang:QYPingFangSCRegular size:15.0] constrainedToWidth:SCREEN_W - 30];
//
//    CGFloat height1 = [string heightWithFont:[UIFont fontPingFang:QYPingFangSCRegular size:15.0] constrainedToWidth:SCREEN_W - 30 numberLines:3];
//
//    NSLog(@"%f %f %f", size.height, height, height1);
//
//
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor redColor];
//    label.font = [UIFont fontPingFang:QYPingFangSCRegular size:15.0];
//    label.textColor = [UIColor greenColor];
//    label.numberOfLines = 3;
//    label.frame = CGRectMake(15, 200, SCREEN_W - 30.0, size.height);
//    label.text = string;
//    [self.view addSubview:label];
//
//    UILabel *label1 = [[UILabel alloc] init];
//    label1.backgroundColor = [UIColor redColor];
//    label1.font = [UIFont fontPingFang:QYPingFangSCRegular size:15.0];
//    label1.textColor = [UIColor greenColor];
//    label1.numberOfLines = 3;
//    label1.frame = CGRectMake(15, 200 + size.height + 15, SCREEN_W - 30.0, height);
//    label1.text = string;
//    [self.view addSubview:label1];
//
//    UILabel *label2 = [[UILabel alloc] init];
//    label2.backgroundColor = [UIColor redColor];
//    label2.font = [UIFont fontPingFang:QYPingFangSCRegular size:15.0];
//    label2.textColor = [UIColor greenColor];
//    label2.numberOfLines = 3;
//    label2.frame = CGRectMake(15, 200 + size.height + height + 15 + 15, SCREEN_W - 30.0, height1);
//    label2.text = string;
//    [self.view addSubview:label2];

    
//    [[[QYBinaryHeapSoft alloc] init] start];

//    _barrierQueue = dispatch_queue_create("com.hackemist.SDWebImageDownloaderBarrierQueue", DISPATCH_QUEUE_SERIAL);
//
//    dispatch_barrier_async(_barrierQueue, ^{
//        DLog(@"block1");
//    });
//
//    dispatch_barrier_async(_barrierQueue, ^{
//        DLog(@"block2");
//    });
//
//    dispatch_barrier_sync(_barrierQueue, ^{
//        DLog(@"同步开启 同步队列2");
//    });
//
//    dispatch_barrier_async(_barrierQueue, ^{
//        DLog(@"block3");
//    });
//
//    dispatch_barrier_async(_barrierQueue, ^{
//        DLog(@"block4");
//    });
//
//    dispatch_barrier_sync(_barrierQueue, ^{
//        DLog(@"同步开启 同步队列1");
//    });
    
//    DLog(@"%llu %lu", [NSProcessInfo processInfo].physicalMemory, [NSProcessInfo processInfo].physicalMemory / 1024 / 1024);
    
//    [self layoutUIOfTableView];
}

- (void)layoutUIOfTableView {
    
    CGFloat height = SCREEN_H - kTopHeight - K_BOTTOM_H(0);
    
    _tableView = [[UPBaseTableView alloc] initWithFrame:CGRectMake(0, kTopHeight, SCREEN_W, height) style:UITableViewStylePlain];
    _tableView.rowHeight = [UPPackageCell up_cellHeight];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorColor = [UIColor colorWithHexString:@"d8d8d8"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    _tableView.delaysContentTouches = NO;
    
    [_tableView registerClass:[UPPackageCell class] forCellReuseIdentifier:[UPPackageCell reuseIdentifier]];
    
    K_IOS11_SET_INSET_NEVER_OC(_tableView)
    K_X_CONTENT_BOTTOM_INSET(_tableView)
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.0)];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
    self.definesPresentationContext = YES;
}


#pragma mark - ======== UITableViewDelegate ========

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DLog(@"点击cell");
}


#pragma mark - ======== UITableViewDataSource ========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UPPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:[UPPackageCell reuseIdentifier] forIndexPath:indexPath];
    cell.up_indexPath = indexPath;
    cell.sliderDelegate = self;
    cell.allowSlider = YES;
    cell.up_tableView = _tableView;
    [cell updatePackageNameWithText:@"test" cardNumber:100];
    return cell;
}

#pragma mark - UPBaseSliderCellDelegate

- (NSArray <UPSliderRowAction *> *)up_sliderRowActionArrayWithTableViewCell:(UPBaseSliderTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {

    UPSliderRowAction *editAction = [self editRowActionWithHandleBlock:^{
        [cell endSliderAnimation];
        DLog(@"点击编辑按钮");
    }];
    
    UPSliderRowAction *deleteAction = [self deleteRowActionWithHandleBlock:^{
        [cell endSliderAnimation];
        DLog(@"点击删除按钮");
    }];
    
    return @[editAction, deleteAction];
}

- (BOOL)up_isAllowSliderTableViewCell:(UPBaseSliderTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UPSliderRowAction *)editRowActionWithHandleBlock:(UPDefNilBlock)handleBlock {
    
    
    UPSliderRowAction *editAction = [UPSliderRowAction sliderRowActionWithType:UPSRATypeImage handleBlock:^{
        CallBackBlock(handleBlock);
    }];
    
    editAction.imageName = @"up_common_edit";
    editAction.bgColor = [UIColor grayColor];
    
    return editAction;
}

- (UPSliderRowAction *)deleteRowActionWithHandleBlock:(UPDefNilBlock)handleBlock {
    
    UPSliderRowAction *deleteAction = [UPSliderRowAction sliderRowActionWithType:UPSRATypeImage handleBlock:^{
        CallBackBlock(handleBlock);
    }];
    
    deleteAction.imageName = @"up_common_delete";
    deleteAction.bgColor = [UIColor grayColor];
    
    return deleteAction;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
