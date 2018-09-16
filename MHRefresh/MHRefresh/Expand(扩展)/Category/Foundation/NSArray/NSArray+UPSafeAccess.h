//
//  NSArray+UPSafeAccess.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (UPSafeAccess)

- (nullable id)up_objectWithIndex:(NSUInteger)index;

- (nullable NSString *)up_stringWithIndex:(NSUInteger)index;

- (nullable NSNumber *)up_numberWithIndex:(NSUInteger)index;

- (nullable NSArray *)up_arrayWithIndex:(NSUInteger)index;

- (nullable NSDictionary *)up_dictionaryWithIndex:(NSUInteger)index;

- (NSInteger)up_integerWithIndex:(NSUInteger)index;

- (NSUInteger)up_unsignedWithIndex:(NSUInteger)index;

- (BOOL)up_boolWithIndex:(NSUInteger)index;

@end

@interface NSMutableArray (UPSafeAccess)

- (void)up_addObject:(id)obj;

- (void)up_addStringObj:(NSString *)stringObj;

- (void)up_addBool:(BOOL)value;

- (void)up_addInteger:(NSInteger)value;

- (void)up_addUnsignedInteger:(NSUInteger)value;

- (void)up_addCGFloat:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
