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


@interface ViewController () <QYPreviewViewControllerDelegate, QYPreviewViewControllerDataSource, UITextViewDelegate> {
    PLAudioPlayer *_audioPlayer;
    QYAudioPlayer *_qy_audio_player;
    FMDatabaseQueue *_dataSerialQueue;
}

@property (nonatomic, strong) MPreviewCardView *cardView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, strong) UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImageView *tempImageView;

@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

__weak NSString *srting_weak_ = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.firstWeekday = 2;
    calendar.minimumDaysInFirstWeek = 4;
    
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setWeekday:2];
    [com setWeekOfYear:1];
//    [com setWeekdayOrdinal:1];
    [com setYear:2018];
    
//    com.day = 1;
//    com.month = 1;
//    com.year = 2018;
    
//    com.timeZone = [NSTimeZone systemTimeZone];
    
    NSDate *date = [calendar dateFromComponents:com];
    
    NSLog(@"%@", date.description);
    
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date];
    
    NSInteger weekday1 = [calendar component:NSCalendarUnitWeekOfYear fromDate:date];
    
    NSLog(@"%ld %ld", weekday, weekday1);
    
//    NBPhoneNumberUtil *util = [NBPhoneNumberUtil sharedInstance];
    
//    NSLog(@"%@", [util DIGIT_MAPPINGS]);
//
//    NSLog(@"%@", [NBMetadataHelper CCode2CNMap]);
//
//    NSLog(@"%@", [[[NBMetadataHelper alloc] init] getAllMetadata]);
    
//    __autoreleasing NSError *error = nil;
//    if ([[NBPhoneNumberUtil sharedInstance] isViablePhoneNumber:@"0"]) {
//        DLog(@"是电话号码");
//    } else {
//        DLog(@"不是电话号码");
//    }
//
//    if (error) {
//        DLog(@"%@", error.description);
//    }
    
//    NSString *dataBasePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName = [dataBasePath stringByAppendingPathComponent:@"Memory1.sqlite"];
//    _dataSerialQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
//
//    NSString *sqlString = @"CREATE TABLE IF NOT EXISTS t_subject(subject_uuid CHAR(32) PRIMARY KEY UNIQUE, title VARCHAR(50), rank INTEGER);";
//
//    [_dataSerialQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        [db executeUpdate:sqlString];
//    }];
//
//    NSString *sqlString1 = @"INSERT INTO t_subject(subject_uuid, title, rank) VALUES (?, ?, ?)";
//    NSString *sqlString11 = @"INSERT INTO t_subject(subject_uuid, title, rank) VALUES (?, ?, ?)";
//    NSString *sqlString12 = @"INSERT INTO t_subject(subject_uuid, title, rank) VALUES (?, ?, ?)";
//    [_dataSerialQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        [db executeUpdate:sqlString1, @"1", @"这是一个测试1", @(15167)];
//        [db executeUpdate:sqlString11, @"2", @"这是一个测试2", @(15168)];
//        [db executeUpdate:sqlString12, @"3", @"这是一个测试3", @(15169)];
//    }];
//
//    NSString *sqlString2 = @"SELECT subject_uuid, title, rank FROM t_subject";
//    [_dataSerialQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        FMResultSet *set = [db executeQuery:sqlString2];
//        while ([set next]) {
//            NSLog(@"%@/%@/%ld", [set stringForColumn:@"subject_uuid"], [set stringForColumn:@"title"], [set longForColumn:@"rank"]);
//        }
//    }];
//
//    NSString *sqlString3 = @"UPDATE t_subject SET title = ?, rank = ? WHERE subject_uuid = ?";
//    [_dataSerialQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        [db executeUpdate:sqlString3, @"这是一个测试5", @(24455344), @"1"];
//    }];
//
//    [_dataSerialQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
//        FMResultSet *set = [db executeQuery:sqlString2];
//        while ([set next]) {
//            NSLog(@"%@/%@/%ld", [set stringForColumn:@"subject_uuid"], [set stringForColumn:@"title"], [set longForColumn:@"rank"]);
//        }
//    }];
    
    

//    NSLocalizedString(@"ceshi", @"This is a ceshi");
    
//    __Require_Quiet(<#assertion#>, <#exceptionLabel#>)
//    NSObject *object = nil;
//    __Require_noErr_Quiet(0, _out);
//    DLog(@"我被执行了1");
//
//_out:
//    DLog(@"我被执行了");
    
//    MNetworkDownloadRequest *downloadRequest = [MNetworkDownloadRequest requestWithCustomUrl:@"https://oiijtsooa.qnssl.com/根回し 染みる 徹する従来.mp3"];
//    MNetworkDownloadRequest *downloadRequest = [MNetworkDownloadRequest downloadRequestWithCustomUrl:@"https://oiijtsooa.qnssl.com/根回し 染みる 徹する従来.mp3" downloadType:MNetworkDownloadTypeAudio downloadPriority:MNetworkRequestPriorityDefault];
//
//    [downloadRequest startWithProgressBlock:^(CGFloat progress) {
//        DLog(@"%f", progress);
//    } success:^(MNetworkBaseRequest * _Nullable request) {
//        DLog(@"下载成功");
//    } failure:^(MNetworkBaseRequest * _Nullable request) {
//        DLog(@"下载失败");
//    } immediately:YES];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFCompoundResponseSerializer *ser = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer], [AFImageResponseSerializer serializer]]];
//    manager.responseSerializer = ser;
//    ser.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"video/mp4", @"audio/mp3", nil];
    
//    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        DLog(@"%f", downloadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DLog(@"下载成功");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLog(@"下载失败");
//    }];
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
//
//    self.tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W)];
//    self.tempImageView.center = CGPointMake(SCREEN_W / 2.0, 200);
//    self.tempImageView.contentMode = UIViewContentModeCenter;
//    [view addSubview:self.tempImageView];
//
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btn setTitle:@"按钮" forState:UIControlStateNormal];
//    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.btn addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
//    self.btn.frame = CGRectMake(0, 300, 60, 40);
//    [self.view addSubview:self.btn];
//    [self layoutUIOfSelf];
//
//    UITextView *textView = [[UITextView alloc] init];
//    textView.frame = CGRectMake(15, 50, SCREEN_W - 30, 100);
//    [textView becomeFirstResponder];
//    textView.delegate = self;
//    [self.view addSubview:textView];
//    self.textView = textView;
//
//    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//
//    NSObject *obj = [[NSObject alloc] init];
//    DLog(@"1 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)obj));
//
//    NSObject *__weak weakObj = obj;
//    DLog(@"2 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)obj));
//    DLog(@"3 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)weakObj));
//    NSObject *obj2 = obj;
//    DLog(@"4 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)obj));
    
//    obj = nil;
//    NSLog(@"Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)weakObj));
    
//    void (^aBlock)(void) = ^() {
        //
//        DLog(@"%@",weakObj);
//        DLog(@"5 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)weakObj));
//        DLog(@"6 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)weakObj));
//    };
//    aBlock();
//    DLog(@"7 Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)obj));
    
//    if (@available(iOS 11.0, *)) {
//        DLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
//    } else {
//        // Fallback on earlier versions
//    }
    
    
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    DLog(@"11%@", filePath);
//
//    filePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
//    DLog(@"22%@", filePath);
//
//    filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    DLog(@"33%@", filePath);
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
////        dispatch_group_t group = dispatch_group_create();
////
////        dispatch_group_enter(group);
//
//        __block int count = 0;
//
//        void (^test)(void) = ^{
//            count++;
//            if (count >= 10) {
//                dispatch_semaphore_signal(semaphore);
//                DLog(@"释放信号量");
//            }
//        };
//
//        for (int i = 0; i < 10; i++) {
//            DLog(@"开始循环");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                test();
//            });
//        }
//
//        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
//        dispatch_semaphore_wait(semaphore, timeout);
////        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        DLog(@"开始执行");
//    });
    
    
//#define kDevice_iPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)
//    // 或者
//    if (UIScreen.mainScreen.bounds.size.height == 812) {
//        NSLog(@"this is iPhone X");
//    }

//
//    #define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen ma
    //场景一
//    NSString *string = [NSString stringWithFormat:@"qy"];
//    srting_weak_ = string;
    
    //场景二
//    @autoreleasepool {
//        NSString *string = [NSString stringWithFormat:@"qy"];
//        srting_weak_ = string;
//    }
    
//    //场景三
//    NSString *string = nil;
//    @autoreleasepool {
//        string = [NSString stringWithFormat:@"qy"];
//        string_weak_ = string;
//    }
    
//    DLog(@"string 0 - %@", srting_weak_);
    
    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//
//    NSInteger user_id = 3725;
//
//    [dictionary setValue:@(user_id) forKey:@"user_id"];
//
//    DLog(@"测试");
    
    
    //多选测试
//    [self multiSelectTest];
    
    //QYLintcode
//    [[[QYMaxAverageSubArray alloc] init] qy_lintcodeSolution];
//    [[[QYCircleSubString alloc] init] qy_lintcodeSolution];
//    [[[QYMaxLengthOrder alloc] init] qy_lintcodeSolution];
    [[[QYMinimumCycleSection alloc] init] qy_lintcodeSolution];
    
//    QYPlayerTest *test = [[QYPlayerTest alloc] init];
//
//    _audioPlayer = [PLAudioPlayer initWithAudioFileSource:test];
//    [_audioPlayer play];
//
//    DLog(@"%f", _audioPlayer.duration);
//
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _audioPlayer.playRate = 2.0;
//        [_audioPlayer seekTime:80.0];
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(14.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [_audioPlayer seekTime:0];
//    });
    
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_audioPlayer play];
////        [_audioPlayer seekTime:100.0];
//    });

    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"AAA" ofType:@"mp3"];
//    _qy_audio_player = [[QYAudioPlayer alloc] initWithFilePath:path fileType:kAudioFileMP3Type];
//    [_qy_audio_player play];
//    _qy_audio_player.duration;
}

- (void)multiSelectTest {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"测试多选" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(multiSelect:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 200, 30);
    button.center = CGPointMake(self.view.sm_width / 2.0, self.view.sm_height / 2.0);
    
    [self.view addSubview:button];
}

- (void)multiSelect:(UIButton *)btn {
    QYMultiSelectViewController *vc = [[QYMultiSelectViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.inputAccessoryView.backgroundColor = [UIColor blueColor];
    self.textView.inputView.backgroundColor = [UIColor redColor];
}

- (void)safeAreaInsetsDidChange API_AVAILABLE(ios(11.0),tvos(11.0)) {
    DLog(@"%@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOtherPreviewCardView {
    self.cardView = [[MPreviewCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.cardView reloadDataWithSuperView:self.view andCurrentIndex:10];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"string 1 - %@", srting_weak_);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"string 2 - %@", srting_weak_);
    
    [QYCoreAnimationModel testWithVc:self];
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

- (void)logMainThread {
    if ([NSThread isMainThread]) {
        DLog(@"当前是主线程");
    } else {
        DLog(@"当前不是主线程");
    }
}

- (IBAction)button:(UIButton *)sender {
    
    UIImage *image = [UIImage imageNamed:@"ao1"];
    
    UIImage *resultImage = [image m_blurImageWithSize:CGSizeMake(8.0, 8.0) tintColor:[UIColor colorWithHexString:@"000000" alpha:0.5] blurFactor:1.0 maskImage:nil];
    
//    UIImage *resultImage = [image lightImage];
//
//    UIImage *resultImage1 = [image blurredImageWithSize:self.imageView.sm_size tintColor:nil saturationDeltaFactor:0.2 maskImage:nil];
    
    self.imageView.image = resultImage;
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
