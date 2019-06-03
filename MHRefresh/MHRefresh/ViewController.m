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

#import "QYStarScoreView.h"

#import "QYTestTouchViewController.h"

#import "QYFMDBTest.h"

#import "QYSlider.h"

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

@property (nonatomic, strong) dispatch_queue_t dispatch_queue;

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
    
//    QYTestTouchViewController *vc = [[QYTestTouchViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)test {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DLog(@"%@", NSStringFromCGSize([[UIScreen mainScreen] currentMode].size));
        [self test];
    });
}

- (int)sqrt:(int)x {
    // write your code here
    int y = x;
    float xhalf = 0.5f*y;
    int i = *(int*)&x; // get bits for floating VALUE
    i = 0x5f375a86- (i>>1); // gives initial guess y0
    y = *(float*)&i; // convert bits BACK to float
    y = y*(1.5f-xhalf*y*y); // Newton step, repeating increases accuracy
    y = y*(1.5f-xhalf*y*y); // Newton step, repeating increases accuracy
    y = y*(1.5f-xhalf*y*y); // Newton step, repeating increases accuracy
    NSLog(@"%d %d", y, 1 / y);
    return 1 / y;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
//
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//
//    // 创建设置对象
//    WKPreferences *preference = [[WKPreferences alloc]init];
//    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
//    preference.minimumFontSize = 0;
//    //设置是否支持javaScript 默认是支持的
//    preference.javaScriptEnabled = YES;
//    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    preference.javaScriptCanOpenWindowsAutomatically = YES;
//    config.preferences = preference;
//
//    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
//    config.allowsInlineMediaPlayback = YES;
//    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
//    config.requiresUserActionForMediaPlayback = YES;
//    //设置是否允许画中画技术 在特定设备上有效
//    config.allowsPictureInPictureMediaPlayback = YES;
//    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
//    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//
//    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) configuration:config];
//    // UI代理
//    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
//    _webView.allowsBackForwardNavigationGestures = YES;
//    //可返回的页面列表, 存储已打开过的网页
//    WKBackForwardList * backForwardList = [_webView backForwardList];
    
    //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chinadaily.com.cn"]];
    //        [request addValue:[self readCurrentCookieWithDomain:@"http://www.chinadaily.com.cn"] forHTTPHeaderField:@"Cookie"];
    //        [_webView loadRequest:request];

    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baike.baidu.com/item/%E4%BE%9D%E8%B5%96%E5%80%92%E7%BD%AE%E5%8E%9F%E5%88%99/6189149?#1"]]];
    
    [self.view addSubview:_webView];

//
//    QYSlider *slider = [[QYSlider alloc] initWithFrame:CGRectMake(15.0, 200.0, 300.0, 11.0)];
//    [self.view addSubview:slider];
    
//    NSString *omitString = @"…";
//    NSLog(@"%ld", omitString.length);
//
//    NSString *string = @"\r";
//    NSLog(@"%ld", string.length);
//
//    [QYFMDBTest start];
    
    
//    NSArray *carddArray = @[@(2), @(1), @(3)];
//
//    NSArray *result = [carddArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
//
//        if ([obj1 integerValue] > [obj2 integerValue]) {
//            return NSOrderedDescending;
//        }
//
//        return NSOrderedAscending;
//    }];
//
//    NSLog(@"%@", result);
    
    
//    NSMutableArray *familyNameArray = [[NSMutableArray alloc] init];
//
//    NSArray *array = [UIFont familyNames];
//
//    for (id family in array) {
//        NSArray *fonts = [UIFont fontNamesForFamilyName:family];
//        for (id font in fonts) {
//            [familyNameArray addObject:font];
//        }
//    }
//
//    NSLog(@"----------------------------");
//    NSLog(@"%@", familyNameArray);
//    NSLog(@"----------------------------");

//    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL res3 = [(id)[QYStarScoreView class] isKindOfClass:[QYStarScoreView class]];
//    BOOL res4 = [(id)[QYStarScoreView class] isMemberOfClass:[QYStarScoreView class]];
//
//    if (res1) {
//        NSLog(@"res1 == YES");
//    } else {
//        NSLog(@"res1 == NO");
//    }
//
//    if (res2) {
//        NSLog(@"res2 == YES");
//    } else {
//        NSLog(@"res2 == NO");
//    }
//
//    if (res3) {
//        NSLog(@"res3 == YES");
//    } else {
//        NSLog(@"res3 == NO");
//    }
//
//    if (res4) {
//        NSLog(@"res4 == YES");
//    } else {
//        NSLog(@"res4 == NO");
//    }
//
//
//
//    typedef NS_ENUM(NSUInteger, QYTestEnum) {
//
//        UPMeNoteHelpModelEventAlertShare    = 1 << 0,
//        UPMeNoteHelpModelEventAlertReport   = 1 << 1,
//        UPMeNoteHelpModelEventAlertTop      = 1 << 2,
//        UPMeNoteHelpModelEventAlertEdit     = 1 << 3,
//        UPMeNoteHelpModelEventAlertDelete   = 1 << 4,
//
//        UPMeNoteHelpModelEventEditCallBack  = 1 << 5,
//        UPMeNoteHelpModelEventEditCreate    = 1 << 6,
//        UPMeNoteHelpModelEventEditModify    = 1 << 7,
//
//        UPMeNoteHelpModelEventAlertDefault  = UPMeNoteHelpModelEventAlertShare | UPMeNoteHelpModelEventAlertReport,
//        UPMeNoteHelpModelEventAlertGroupTop = UPMeNoteHelpModelEventAlertShare | UPMeNoteHelpModelEventAlertReport | UPMeNoteHelpModelEventAlertTop,
//        UPMeNoteHelpModelEventAlertAll      = UPMeNoteHelpModelEventAlertShare | UPMeNoteHelpModelEventAlertReport | UPMeNoteHelpModelEventAlertTop | UPMeNoteHelpModelEventAlertEdit | UPMeNoteHelpModelEventAlertDelete,
//
//    };
//
//
//    QYTestEnum testEnum = UPMeNoteHelpModelEventAlertDefault;
//
//    if (testEnum & UPMeNoteHelpModelEventAlertShare) {
//        DLog(@"为真1");
//    }
//
//    if (testEnum & UPMeNoteHelpModelEventAlertReport) {
//        DLog(@"为真2");
//    }
//
//    if (testEnum & UPMeNoteHelpModelEventEditCreate) {
//        DLog(@"为真3");
//    }
//
//    int i = 1, j = 1;
//
//    if (i ^ j) {
//        DLog(@"sdf");
//    } else {
//        DLog(@"sdf1");
//    }
//
//    DLog(@"%d", i ^ j);
//
    
//    QYStarScoreView *view = [[QYStarScoreView alloc] initWithFrame:CGRectMake(50.0, 100.0, 209.0, 37.0)];
//    view.starScoreType = QYStarScoreTypeRandom;
//    view.unselectedStarImage = [UIImage imageNamed:@"star_unselected"];
//    view.selectedStarImage = [UIImage imageNamed:@"star_selected"];
//    view.currentScore = 8.4;
//    view.eventEnable = YES;
//    view.scoreUpdateCallBack = ^(CGFloat newScore) {
//        NSLog(@"%.1f", newScore);
//    };
//    [self.view addSubview:view];
//
//    [[[QYTestPrintf alloc] init] qy_test];
    
//
    
//    NSURLComponents *uu = [NSURLComponents componentsWithString:@"jiyiguanjiapackageshare://my-test.jiyiguanjia.com/share/package?uuid=p5955a7651ae3d4431&from=singlemessage&isappinstalled=0"];
//
//    //关键代码
//    for (int i = 0; i<uu.queryItems.count; i++) {
//        NSLog(@"%@", uu.queryItems[i].name);
//        NSLog(@"%@", uu.queryItems[i].value);
//    }

    
    //同步分发任务到队列中  任务会根据分发的顺序执行
    //异步分发任务到同步队列中  任务也会按照顺序执行
    //异步分发任务到异步队列中  任务不会按照顺序执行
//    DISPATCH_QUEUE_SERIAL DISPATCH_QUEUE_CONCURRENT

    
//    UILabel *label = [[UILabel alloc] init];
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"8.4" attributes:@{NSFontAttributeName : [UIFont fontPingFang:(QYPingFangSCRegular) size:21.0], NSForegroundColorAttributeName : [UIColor redColor]}];
//    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"分" attributes:@{NSFontAttributeName : [UIFont fontPingFang:(QYPingFangSCRegular) size:15.0], NSForegroundColorAttributeName : [UIColor blueColor]}]];
//
//    label.frame = CGRectMake(100.0, 100.0, 100.0, 80.0);
//
//    label.attributedText = string;
//
//    [self.view addSubview:label];
    
    
//    [[[QYBinaryHeapSoft alloc] init] start];
//    [[[QYMaoPaoSoft alloc] init] start];
//    [[[QYXuanZeSoft alloc] init] start];
//    [[[QYZhiJieChaRuSoft alloc] init] start];
//    [[[QYGuiBingSoft alloc] init] start];
//    [[[QYKuaisupaixu alloc] init] start];
//    DLog(@"%ld", NSIntegerMin);
    
    
//    if (20 > 20) {
//        DLog(@"20 > 20");
//    } else {
//        DLog(@"20 < 20");
//    }
    
//
//    NSString *string = @"中国";
//    NSString *string1 = @"ABCD";
//    NSString *string3 = @"☺";
//
//
//
//    DLog(@"%ld - %ld - %ld", string.length, string1.length, string3.length);
//
//    DLog(@"%ld - %ld - %ld", string.charNumber, string1.charNumber, string3.charNumber);
    
//    string = [string substringWithRange:NSMakeRange(0, 0)];
    
    
//    NSInteger sum = 0;
//
//
//    NSInteger index = 4;
//
//    NSString *subStr = [[NSString alloc] init];
//
//    for(int i = 0; i<[string3 length]; i++){
//
//        unichar strChar = [string3 characterAtIndex:i];
//
//        if(strChar < 256){
//            sum += 1;
//        }
//        else {
//            sum += 2;
//        }
//
//        if (sum >= index) {
//
//            subStr = [string3 substringToIndex:i+1];
//            break;
//        }
//    }
//
//    if (string3.charNumber < index) {
//        subStr = string3;
//    }
//
//    DLog(@"%@", subStr);
    
    
    
    
//    _resultArray = [@[@"1", @"2", @"3"] mutableCopy];
//
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//        return [@"1" isEqualToString:evaluatedObject];
//    }];
//
//    DLog(@"%@", _resultArray);
//
//    [_resultArray filterUsingPredicate:predicate];
//
//    DLog(@"%@", _resultArray);
//
//
//    NSArray *array = @[@"1", @"2", @"3"];
//    DLog(@"%@", array);
//    array = [array filteredArrayUsingPredicate:predicate];
//    DLog(@"%@", array);
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
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 150)];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    view2.backgroundColor = [UIColor greenColor];
    view3.backgroundColor = [UIColor redColor];
    [view2 addSubview:view3];
    
    _tableView.tableHeaderView = view2;
    
    [_tableView sendSubviewToBack:view2];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.0)];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
    self.definesPresentationContext = YES;
    
    [_tableView sendSubviewToBack:_tableView.tableHeaderView];
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

