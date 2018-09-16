//
//  NSDate+UPExtension.m
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSDate+UPExtension.h"

@implementation NSDate (UPExtension)

+ (NSInteger)timestamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSInteger)todaySecondPast {
    
    NSInteger current = [self timestamp];
    return current - [self getFirstSecondForTheTimestamp:current];
}

+ (NSInteger)getFirstSecondForTheTimestamp:(NSInteger)timestamp {
    
    if (timestamp == 0) {
        return 0;
    }
    
    NSInteger todaySeconds = timestamp % UPDaySeconds;
    NSInteger todayNewSecond = 0;
    if (todaySeconds > UPDaySeconds - UPNMOSeconds) {
        todayNewSecond = timestamp - (todaySeconds - (UPDaySeconds - UPNMOSeconds));
    } else {
        todayNewSecond = timestamp - todaySeconds - UPNMOSeconds;
    }
    
    return todayNewSecond;
}

+ (BOOL)beforeNow:(NSInteger)timestamp {
    
    return timestamp <= [self timestamp];
}

+ (BOOL)isToday:(NSInteger)timeStamp {
    
    NSInteger todayFirstSecond = [self getFirstSecondForTheTimestamp:[self timestamp]];
    if (timeStamp < todayFirstSecond || timeStamp - todayFirstSecond >= UPDaySeconds) {
        return NO;
    }
    return YES;
}

+ (BOOL)isTomorrow:(NSInteger)timestamp {
    
    NSInteger tomorrowFirstSecond = [self getFirstSecondForTheTimestamp:[self timestamp]] + UPDaySeconds;
    if (tomorrowFirstSecond <= timestamp && tomorrowFirstSecond + UPDaySeconds > timestamp) {
        return YES;
    }
    return NO;
}

+ (BOOL)afterToday:(NSInteger)timestamp {
    
    NSInteger tomorrowFirstSecond = [self getFirstSecondForTheTimestamp:[self timestamp]] + UPDaySeconds;
    
    return timestamp >= tomorrowFirstSecond;
}

+ (BOOL)isLastWeek:(NSInteger)timeStamp {
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger weekDay = [comp weekday];
    NSInteger day = [comp day];
    
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = -6;
    } else {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
    }
    
    [comp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comp];
    NSInteger lastWeekday = [firstDayOfWeek timeIntervalSince1970];
    NSInteger lastMonday = lastWeekday - 7 * UPDaySeconds;
    
    if (timeStamp < lastWeekday && timeStamp > lastMonday) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isTodayIsMonday {
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:nowDate];
    
    NSInteger weekDay = [comp weekday];
    
    if (weekDay == 2) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark -

+ (NSInteger)todayBegin {
    return [self getFirstSecondForTheTimestamp:[self timestamp]];
}

+ (NSInteger)yerterdayBegin {
    return [self todayBegin] - UPDaySeconds;
}

+ (NSInteger)nextDay {
    return [self getFirstSecondForTheTimestamp:[self timestamp]] + UPDaySeconds;
}

+ (NSInteger)nextWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 2;
    
    NSDate *date = [calendar nextDateAfterDate:[NSDate date] matchingComponents:components options:NSCalendarMatchStrictly];
    return [date timeIntervalSince1970];
}

+ (NSInteger)nextMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    
    NSDate *date = [calendar nextDateAfterDate:[NSDate date] matchingComponents:components options:NSCalendarMatchStrictly];
    return [date timeIntervalSince1970];
}

+ (BOOL)judgeIsMonthFirstDay {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"HTC"];
    NSString *string = [formatter stringFromDate:[NSDate date]];
    
    if ([string isEqualToString:@"01"]) {
        return YES;
    }
    
    return NO;
}

+ (NSInteger)lastMonday {
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger weekDay = [comp weekday];
    NSInteger day = [comp day];
    
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = -6;
    } else {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
    }
    
    [comp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comp];
    NSInteger lastWeekday = [firstDayOfWeek timeIntervalSince1970];
    NSInteger lastMonday = lastWeekday - 7 * UPDaySeconds;
    
    return lastMonday;
}

+ (NSDate *)nextMonday:(NSInteger)timeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSInteger weekDay = [comp weekday];
    NSInteger day = [comp day];
    
    long lastDiff;
    if (weekDay == 1) {
        lastDiff = 0;
    } else {
        lastDiff = 8 - weekDay;
    }
    
    [comp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:comp];
    
    NSTimeInterval lastWeek = [lastDayOfWeek timeIntervalSince1970];
    
    lastWeek = lastWeek + UPDaySeconds;
    
    NSDate *mondayDate = [NSDate dateWithTimeIntervalSince1970:lastWeek];
    
    return mondayDate;
}

@end
