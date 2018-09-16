//
//  NSArray+UPSafeAccess.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSArray+UPSafeAccess.h"

@implementation NSArray (UPSafeAccess)

- (nullable id)up_objectWithIndex:(NSUInteger)index {
    
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

- (nullable NSString *)up_stringWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    
    if (nil == value) {
        return nil;
    }
    
    if ([value isNullClass]) {
        return nil;
    }
    
    if ([value isStringClass]) {
        return (NSString *)value;
    }
    
    if ([value isNumberClass]) {
        return [value stringValue];
    }
    
    return nil;
}

- (nullable NSNumber *)up_numberWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    
    if (nil == value) {
        return nil;
    }
    
    if ([value isNumberClass]) {
        return (NSNumber *)value;
    }
    
    if ([value isStringClass]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter numberFromString:(NSString *)value];
    }
    
    return nil;
}

- (nullable NSArray *)up_arrayWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    
    if (value == nil ||
        [value isNullClass]) {
        return nil;
    }
    
    if ([value isArrayClass]) {
        return value;
    }
    
    return nil;
}

- (nullable NSDictionary *)up_dictionaryWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    
    if (nil == value ||
        [value isNullClass]) {
            return nil;
    }
    
    if ([value isDictionaryClass]) {
        return (NSDictionary *)value;
    }
    
    return nil;
}

- (NSInteger)up_integerWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    
    if ([value isStringClass] ||
        [value isNumberClass]) {
        return [value integerValue];
    }
    
    return 0;
}

- (NSUInteger)up_unsignedWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    
    if ([value isStringClass] ||
        [value isNumberClass]) {
        return [value unsignedIntegerValue];
    }
    
    return 0;
}

- (BOOL)up_boolWithIndex:(NSUInteger)index {
    
    id value = [self up_objectWithIndex:index];
    return [value boolValue];
}

@end


@implementation NSMutableArray (UPSafeAccess)

- (void)up_addObject:(id)obj {
    if (nil == obj) {
        return;
    }
    
    [self addObject:obj];
}

- (void)up_addStringObj:(NSString *)stringObj {
    [self up_addObject:stringObj];
}

- (void)up_addBool:(BOOL)value {
    [self addObject:@(value)];
}

- (void)up_addInteger:(NSInteger)value {
    [self addObject:@(value)];
}

- (void)up_addUnsignedInteger:(NSUInteger)value {
    [self addObject:@(value)];
}

- (void)up_addCGFloat:(CGFloat)value {
    [self addObject:@(value)];
}

@end
