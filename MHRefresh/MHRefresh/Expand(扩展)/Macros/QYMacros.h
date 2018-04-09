//
//  QYMacros.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYMacros_h
#define QYMacros_h

#ifdef __OBJC__
//打印
#ifdef DEBUG
    #define DLog(...) NSLog(__VA_ARGS__)
#else
    #define DLog(...)
#endif

//屏幕适配
#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)

//屏幕缩放适配 相对于6来说
#define SCREEN_W_SCALE ([UIScreen mainScreen].bounds.size.width / 375)
#define SCREEN_H_SCALE ([UIScreen mainScreen].bounds.size.height / 667)

#define MAX_X(frame) CGRectGetMaxX(frame)
#define MIN_X(frame) CGRectGetMinX(frame)
#define MAX_Y(frame) CGRectGetMaxY(frame)
#define MIN_Y(frame) CGRectGetMinY(frame)

#define DLOG_DEALLOC DLog(@"%@ dealloc", NSStringFromClass([self class]));

//iPhoneX
#define kIsiPhoneX (CGSizeEqualToSize(CGSizeMake(375.0f, 812.0f), [[UIScreen mainScreen] bounds].size) || \
CGSizeEqualToSize(CGSizeMake(812.0f, 375.0f), [[UIScreen mainScreen] bounds].size))

#define kStatusExtraHeight 24.0  //x 状态栏额外高度
#define kHomeIndicator 34.0  //x 底部  额外 高度

#define kStatusBarHeight ((kIsiPhoneX == YES) ? 44.0 : 20.0)
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define kTabBarHeight 49.0
#define kBottomHeight ((kIsiPhoneX == YES) ? kTabBarHeight + kHomeIndicator : kTabBarHeight)

#define K_TOP_H(number) (kIsiPhoneX ? number + kStatusExtraHeight : number)  //x附加状态栏额外高度
#define K_BOTTOM_H(number) (kIsiPhoneX ? number + kHomeIndicator : number)   //x附加底部高度

#define K_X_CONTENT_BOTTOM_INSET_HEIGHT(inset, height) \
if (kIsiPhoneX) {  \
inset.contentInset = UIEdgeInsetsMake(inset.contentInset.top, inset.contentInset.left, inset.contentInset.bottom + height, inset.contentInset.right);  \
} else {\
inset.contentInset = UIEdgeInsetsMake(inset.contentInset.top, inset.contentInset.left, inset.contentInset.bottom, inset.contentInset.right);\
} //传入对象的inset 调整内容边距

#define K_X_CONTENT_BOTTOM_INSET(inset) K_X_CONTENT_BOTTOM_INSET_HEIGHT(inset, kHomeIndicator)

//iOS11 content adjust
#define K_IOS11_CLOSE_AUTOADJUSTINSET(object)\
if (@available(iOS 11.0, *)) {  \
\
} else {  \
object.automaticallyAdjustsScrollViewInsets = NO;\
}

#define K_IOS11_SET_INSET_NEVER_OC(object) \
if (@available(iOS 11.0, *)) {  \
object.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
}

#define K_IOS11_SET_INSET_NEVER_AND_ADJUST_WITH_TABBAR_OC(object) \
if (@available(iOS 11.0, *)) {  \
object.contentInset = UIEdgeInsetsMake(object.contentInset.top, object.contentInset.left, object.contentInset.bottom + kBottomTotalHeight, object.contentInset.right);\
object.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
}

//当前缩放
#define SCREEN_SCALE [UIScreen mainScreen].scale

//app版本号
#define FAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define DAppVersion [[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] doubleValue]

//系统版本
#define FSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion ([[UIDevice currentDevice] systemVersion])

#define IS_iOS_7_Later  (FSystemVersion >= 7.0)
#define IS_iOS_8_Later  (FSystemVersion >= 8.0)
#define IS_iOS_9_Later  (FSystemVersion >= 9.0)
#define IS_iOS_10_Later (FSystemVersion >= 10.0)
#define IS_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//颜色
#define RGBA(r, g, b, a)      [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define RGB(r, g, b)          RGBA(r, g, b, 1.0)
#define HEXCOLOR(hex)         [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 \
                                blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define COLOR_RGB(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 \
                                blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]
#define RANDOM  (double)arc4random_uniform(256) / 255.0
#define RANDOMCOLOR [UIColor colorWithRed:RANDOM green:RANDOM blue:RANDOM alpha:1.0]

//获取单例
#define SharedApplication           [UIApplication sharedApplication]
#define KeyWindow                   [UIApplication sharedApplication].keyWindow
#define UserDefaults                [NSUserDefaults standardUserDefaults]
#define NotificationCenter          [NSNotificationCenter defaultCenter]
#define GroupUserDefaults(string)   [[NSUserDefaults alloc] initWithSuiteName:string]

//为空判断
//字符串是否为空
#define StringIsEmpty(string) ([string isKindOfClass:[NSNull class]] || string == nil || [string length] < 1 ? YES : NO )
//数组是否为空
#define ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define DictionaryIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//由角度转换弧度
#define DegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define RadianToDegrees(radian) (radian * 180.0) / (M_PI)

//引用
#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#ifdef LocalizedString
#error 宏定义出错
#else
#define LocalizedString(key) NSLocalizedString(key, nil)
#endif

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//Library/Caches 文件路径
#define FilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
//获取temp
#define PathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//函数已废弃
#define DEPRECATED(explain) __attribute__((deprecated(explain)))
#define ALREADY_DEPRECTED MEMORY_DEPRECATED("already deprected")

#ifndef dispatch_async_main_safe
#define dispatch_async_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#endif

#endif /* QYMacros_h */
