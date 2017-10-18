//
//  NSArray+QYSafeAccess.h
//  MHRefresh
//
//  Created by developer on 2017/10/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (QYSafeAccess)

-(id)objectWithIndex:(NSUInteger)index;

- (NSString*)stringWithIndex:(NSUInteger)index;

- (NSNumber*)numberWithIndex:(NSUInteger)index;

- (NSDecimalNumber *)decimalNumberWithIndex:(NSUInteger)index;

- (NSArray*)arrayWithIndex:(NSUInteger)index;

- (NSDictionary*)dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)integerWithIndex:(NSUInteger)index;

- (NSUInteger)unsignedIntegerWithIndex:(NSUInteger)index;

- (BOOL)boolWithIndex:(NSUInteger)index;

- (int16_t)int16WithIndex:(NSUInteger)index;

- (int32_t)int32WithIndex:(NSUInteger)index;

- (int64_t)int64WithIndex:(NSUInteger)index;

- (char)charWithIndex:(NSUInteger)index;

- (short)shortWithIndex:(NSUInteger)index;

- (float)floatWithIndex:(NSUInteger)index;

- (double)doubleWithIndex:(NSUInteger)index;

- (NSDate *)dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat;
//CG
- (CGFloat)CGFloatWithIndex:(NSUInteger)index;

- (CGPoint)pointWithIndex:(NSUInteger)index;

- (CGSize)sizeWithIndex:(NSUInteger)index;

- (CGRect)rectWithIndex:(NSUInteger)index;

@end

@interface NSMutableArray (QYSafeAccess)

- (void)addObj:(id)i;

- (void)addString:(NSString *)i;

- (void)addBool:(BOOL)i;

- (void)addInt:(int)i;

- (void)addInteger:(NSInteger)i;

- (void)addUnsignedInteger:(NSUInteger)i;

- (void)addCGFloat:(CGFloat)f;

- (void)addChar:(char)c;

- (void)addFloat:(float)i;

- (void)addPoint:(CGPoint)o;

- (void)addSize:(CGSize)o;

- (void)addRect:(CGRect)o;

@end
