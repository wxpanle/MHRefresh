//
//  NSUserDefaults+UPSafeAccess.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (UPSafeAccess)

+ (NSString *)up_stringForKey:(NSString *)defaultName;
+ (NSArray *)up_arrayForKey:(NSString *)defaultName;
+ (NSDictionary *)up_dictionaryForKey:(NSString *)defaultName;
+ (NSData *)up_dataForKey:(NSString *)defaultName;
+ (NSArray *)up_stringArrayForKey:(NSString *)defaultName;
+ (NSInteger)up_integerForKey:(NSString *)defaultName;

+ (float)up_floatForKey:(NSString *)defaultName;
+ (double)up_doubleForKey:(NSString *)defaultName;
+ (BOOL)up_boolForKey:(NSString *)defaultName;
+ (NSURL *)up_URLForKey:(NSString *)defaultName;

+ (void)up_syncSetInteger:(NSInteger)value key:(NSString *)key;
+ (void)up_syncSetFloat:(float)value key:(NSString *)key;
+ (void)up_syncSetDouble:(double)value key:(NSString *)key;
+ (void)up_syncSetBool:(BOOL)value key:(NSString *)key;
+ (void)up_syncSetURL:(NSURL *)url key:(NSString *)key;

+ (void)up_asyncSetInteger:(NSInteger)value key:(NSString *)key;
+ (void)up_asyncSetFloat:(float)value key:(NSString *)key;
+ (void)up_asyncSetDouble:(double)value key:(NSString *)key;
+ (void)up_asyncSetBool:(BOOL)value key:(NSString *)key;
+ (void)up_asyncSetURL:(NSURL *)url key:(NSString *)key;

#pragma mark - WRITE FOR STANDARD

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)arcObjectForKey:(NSString *)defaultName;

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)setArcObject:(id)value forKey:(NSString *)defaultName;

@end
