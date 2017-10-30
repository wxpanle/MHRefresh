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
#import <MBProgressHUD/MBProgressHUD.h>

#if __has_include(<SDWebImage/SDWebImageDownloader.h>)
#import <SDWebImage/SDWebImageDownloader.h>
#else
#import "SDWebImageDownloader.h"
#endif

@interface ViewController () <QYPreviewViewControllerDelegate, QYPreviewViewControllerDataSource>

@property (nonatomic, strong) MPreviewCardView *cardView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) NSInteger number;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    [self layoutUIOfSelf];
//    [self arithmeti];
//    [self addImage];
    
//    DLog(@"系统字节数 %ld", [UIDevice ramSize]);
//    DLog(@"系统字节数 %llu", [NSProcessInfo processInfo].physicalMemory);
    
    
}

- (BOOL)isEmail {
    
    NSString *string = _textField.text;
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"^[A-Za-z0-9_]{6,18}@[A-Za-z0-9.]+\\.[A-Za-z]{2,3}$" options:0 error:nil];
    NSArray *array = [regular matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    BOOL flag = [string hasSuffix:@".com"] || [string hasSuffix:@".cn"] || [string hasSuffix:@".net"];
    return array.count && flag;
}

- (BOOL)isPhoneNumber {
    
    /**
     *  手机号以13、15、18、170开头，8个 \d 数字字符
     */
    NSString *mobileNoRegex = @"^1((3\\d|5[0-35-9]|8[025-9])\\d|70[059])\\d{7}$";
    
    return [self isValidateByRegex:mobileNoRegex];
}

- (BOOL)isValidateByRegex:(NSString *)regex {
    NSString *string = _textField.text;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:string];
}

- (BOOL)isVerifyCode {
    
    NSString *string = _textField.text;
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]{6}$" options:0 error:nil];
    NSArray *array = [regular matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return array.count != 0 ? YES : NO;
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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    progressHUD.label.text = @"测试";
//    progressHUD.label.textColor = [UIColor redColor];
//    progressHUD.removeFromSuperViewOnHide = YES;
//
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"https://oiijtsooa.qnssl.com/ao1.png"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//
//        if ([NSThread isMainThread]) {
//            DLog(@"下载进度 当前是主线程");
//        } else {
//            DLog(@"下载进度 当前不是主线程");
//        }
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if ([NSThread isMainThread]) {
//            DLog(@"下载完成 当前是主线程");
//        } else {
//            DLog(@"下载完成 当前不是主线程");
//        }
//    }];
//
//    NSString *str = @"中国";
//
//    NSString *str1 = [str pinyinWithPhoneticSymbol];
//    NSString *str2 = [str pinyin];
//    NSArray *str3 = [str pinyinArray];
//    NSString *str4 = [str pinyinWithoutBlank];
//    NSArray *str5 = [str pinyinInitialsArray];
//    NSString *str6 = [str pinyinInitialsString];
//
//    DLog(@"11");
//
//    NSString *newInfoStr = @"https://itunes.apple.com/cn/app/%E9%87%8E%E8%9B%AE%E4%BA%BA%E5%A4%A7%E4%BD%9C%E6%88%98-%E5%A4%A7%E9%80%83%E6%9D%80/id1254324286?mt=8";
//
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:newInfoStr]]) {
//        DLog(@"可以跳转");
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:newInfoStr] options:@{} completionHandler:nil];
//    }
    
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%87%8E%E8%9B%AE%E4%BA%BA%E5%A4%A7%E4%BD%9C%E6%88%98-%E5%A4%A7%E9%80%83%E6%9D%80/id1254324286?mt=8"] options:@{} completionHandler:nil];
    
    
    
//    方式二：
}

- (void)logMainThread {
    if ([NSThread isMainThread]) {
        DLog(@"当前是主线程");
    } else {
        DLog(@"当前不是主线程");
    }
}

- (IBAction)judhe:(UIButton *)sender {
    
    if ([self isEmail]) {
        DLog(@"是邮箱");
    } else {
        DLog(@"不是邮箱");
    }
    
    if ([self isPhoneNumber]) {
        DLog(@"是电话");
    } else {
        DLog(@"不是电话");
    }
    
    if ([self isVerifyCode]) {
        DLog(@"是验证码");
    } else {
        DLog(@"不是验证码");
    }
    
}

//+ (NSString *)encode(String str) {
//
//}

////将字符转为unicode
//public static String encode(String str) {
//    if (null == str || str.equals(""))
//        return "输入字符";
//    StringBuffer sb = new StringBuffer();
//    try {
//        //用16bit数字编码表示一个字符，每8bit用byte表示。
//        byte bytesUtf16[] = str.getBytes("UTF-16");
//        for (int n = 0; n < bytesUtf16.length; n++) {
//            // 截取后面8位，并用16进制表示。
//            str = (java.lang.Integer.toHexString(bytesUtf16[n] & 0XFF));
//            // 将获得的16进制表示连成串
//            sb.append((str.length() == 1) ? ("0" + str) : str);
//        }
//        // 去除第一个标记字符
//        str = sb.toString().toUpperCase().substring(4);
//        char[] chs = str.toCharArray();
//        str = "";
//        for (int i = 0; i < chs.length; i = i + 4) {
//            str += "\\u" + chs[i] + chs[i+1] + chs[i+2] + chs[i+3];
//        }
//    } catch (Exception e) {
//        System.out.print(e.getMessage());
//        str = "程序出现异常";
//    } finally {
//        return str;
//    }
//}
//
////將unicode转为字符
//public static String decode(final String str) {
//    if(null == str || str.equals("")){
//        return "輸入unicode";
//    }
//    //用正则表达式验证
//    Pattern p = Pattern.compile("(\\\\u[0-9a-fA-F]{4})+");
//    Matcher m = p.matcher(str);
//    if(!(m.find() && m.group().equals(str))){
//        return "非法格式";
//    }
//    String[] strs = str.split("u");
//    StringBuffer sb = new StringBuffer();
//    for (int i = 1; i <= strs.length - 1; i++) {
//        sb.append(new Character((char) Integer.parseInt(strs[i].replace("\\", ""), 16)));
//    }
//    return sb.toString();
//}

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
