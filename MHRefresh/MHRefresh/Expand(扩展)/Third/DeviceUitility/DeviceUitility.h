//
//  DeviceUitility.h
//  DeviceUitility
//
//  Created by Jivan on 2017/10/8.
//  Copyright © 2017年 Jivan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeviceUitility : NSObject
/// 屏幕宽度
+ (CGFloat)getDeviceScreenWidth;
/// 屏幕高度
+ (CGFloat)getDeviceScreenHeight;

/// 获取设备型号然后手动转化为对应名称
- (NSString *)getDeviceName;

/// 获取iPhone名称
+ (NSString *)getiPhoneName;

/// 获取app版本号
+ (NSString *)getAPPVerion;

/// 获取电池电量
+ (CGFloat)getBatteryLevel;
/// 当前系统名称
+ (NSString *)getSystemName ;

/// 当前系统版本号
+ (NSString *)getSystemVersion;

/// 通用唯一识别码UUID
+ (NSString *)getUUID;
// 获取当前设备IP
+ (NSString *)getDeviceIPAdress;
/// 获取精准电池电量
+ (CGFloat)getCurrentBatteryLevel;

/// 获取电池当前的状态，共有4种状态
+ (NSString *) getBatteryState;
/// 获取当前语言
+ (NSString *)getDeviceLanguage;

/// CPU总数目
+ (NSUInteger)getCPUCount;
/// 获取磁盘总空间
+ (int64_t)getTotalDiskSpace;
/// 获取未使用的磁盘空间
+ (int64_t)getFreeDiskSpace;
/// 获取已使用的磁盘空间
+ (int64_t)getUsedDiskSpace;
/// 系统总内存空间
+ (int64_t)getTotalMemory;
/// 活跃的内存,正在使用或者很短时间内被使用过
+ (int64_t)getActiveMemory;
/// 最近使用过,但是目前处于不活跃状态的内存
+ (int64_t)getInActiveMemory;

/// 空闲的内存空间
+ (int64_t)getFreeMemory;

/// 已使用的内存空间
+ (int64_t)getUsedMemory;

/// 用来存放内核和数据结构的内存,framework、用户级别的应用无法分配
+ (int64_t)getWiredMemory;

/// 可释放的内存空间：内存吃紧自动释放，针对大对象存放所需的大块内存空间
+(int64_t)getPurgableMemory;

@end



