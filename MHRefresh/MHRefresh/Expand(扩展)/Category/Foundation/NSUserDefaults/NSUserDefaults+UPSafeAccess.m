//
//  NSUserDefaults+UPSafeAccess.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSUserDefaults+UPSafeAccess.h"

@implementation NSUserDefaults (UPSafeAccess)

+ (NSString *)up_stringForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)up_arrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)up_dictionaryForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)up_dataForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)up_stringArrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)up_integerForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)up_floatForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)up_doubleForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)up_boolForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)up_URLForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

+ (void)up_syncSetInteger:(NSInteger)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)up_syncSetFloat:(float)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)up_syncSetDouble:(double)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)up_syncSetBool:(BOOL)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)up_syncSetURL:(NSURL *)url key:(NSString *)key {
    if (!url || ![url isKindOfClass:[NSURL class]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)up_asyncSetInteger:(NSInteger)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

+ (void)up_asyncSetFloat:(float)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
}

+ (void)up_asyncSetDouble:(double)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
}

+ (void)up_asyncSetBool:(BOOL)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

+ (void)up_asyncSetURL:(NSURL *)url key:(NSString *)key {
    if (!url || ![url isKindOfClass:[NSURL class]]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:key];
}


#pragma mark - WRITE FOR STANDARD

+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)arcObjectForKey:(NSString *)defaultName {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:defaultName]];
}

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)setArcObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
