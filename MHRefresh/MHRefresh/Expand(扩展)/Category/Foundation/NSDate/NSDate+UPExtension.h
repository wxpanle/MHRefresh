//
//  NSDate+UPExtension.h
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UPExtension)

/**
 获取当前的一个时间戳

 @return NSInteger timeIntervalSince1970
 */
+ (NSInteger)timestamp;

/**
 今日已过去的秒数

 @return NSInteger
 */
+ (NSInteger)todaySecondPast;

/**
 获取某一个时间戳对应的当前时间的时间戳

 @param timestamp timestamp
 @return  NSInteger
 */
+ (NSInteger)getFirstSecondForTheTimestamp:(NSInteger)timestamp;

/**
 该时间戳是否在现在之前

 @param timestamp timestamp
 @return BOOL
 */
+ (BOOL)beforeNow:(NSInteger)timestamp;

/**
 该时间戳是否在今日

 @param timeStamp timeStamp
 @return BOOL
 */
+ (BOOL)isToday:(NSInteger)timeStamp;

+ (BOOL)isTomorrow:(NSInteger)timestamp;

+ (BOOL)afterToday:(NSInteger)timestamp;

+ (BOOL)isLastWeek:(NSInteger)timeStamp;

+ (BOOL)isTodayIsMonday;

#pragma mark - 月

+ (NSInteger)todayBegin;

+ (NSInteger)yerterdayBegin;

+ (NSInteger)nextDay;

+ (NSInteger)nextWeek;

+ (NSInteger)nextMonth;

+ (BOOL)judgeIsMonthFirstDay;

+ (NSInteger)lastMonday;

+ (NSDate *)nextMonday:(NSInteger)timeStamp;

@end
