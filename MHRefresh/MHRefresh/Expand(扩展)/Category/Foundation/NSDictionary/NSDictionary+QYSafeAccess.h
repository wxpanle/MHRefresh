//
//  NSDictionary+QYSafeAccess.h
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QYSafeAccess)

- (BOOL)hasKey:(NSString *)key;

- (NSString *)stringForKey:(id)key;

- (NSNumber *)numberForKey:(id)key;

- (NSDecimalNumber *)desimalNumnerForKey:(id)key;

- (NSArray *)arrayForKey:(id)key;

- (NSDictionary *)dictionaryForKey:(id)key;

- (NSInteger)intergerForKey:(id)key;

- (NSUInteger)unsignedIntegerForKey:(id)key;

- (BOOL)boolForKey:(id)key;

- (float)floatForKey:(id)key;

- (double)doubleForKey:(id)key;

- (long long)longLongForKey:(id)key;

- (unsigned long long)unsignedlongLongForKey:(id)key;

- (int16_t)int16ForKey:(id)key;

- (int32_t)int32ForKey:(id)key;

- (int64_t)int64ForKey:(id)key;

- (CGFloat)cgFloatForKey:(id)key;

- (CGPoint)cgPointForKey:(id)key;

- (CGSize)cgSizeForKey:(id)key;

- (CGRect)cgRectForKey:(id)key;

@end


@interface NSMutableDictionary(QYSafeAccess)

- (void)setObj:(id)i forKey:(NSString*)key;

- (void)setString:(NSString*)i forKey:(NSString*)key;

- (void)setBool:(BOOL)i forKey:(NSString*)key;

- (void)setInt:(int)i forKey:(NSString*)key;

- (void)setInteger:(NSInteger)i forKey:(NSString*)key;

- (void)setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

- (void)setCGFloat:(CGFloat)f forKey:(NSString*)key;

- (void)setChar:(char)c forKey:(NSString*)key;

- (void)setFloat:(float)i forKey:(NSString*)key;

- (void)setDouble:(double)i forKey:(NSString*)key;

- (void)setLongLong:(long long)i forKey:(NSString*)key;

- (void)setPoint:(CGPoint)o forKey:(NSString*)key;

- (void)setSize:(CGSize)o forKey:(NSString*)key;

- (void)setRect:(CGRect)o forKey:(NSString*)key;

@end
