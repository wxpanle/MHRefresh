//
//  QYMacros.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYMacros_h
#define QYMacros_h

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

#endif /* QYMacros_h */
