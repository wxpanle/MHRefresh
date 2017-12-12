//
//  NSDictionary+QYSafeAccess.m
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSDictionary+QYSafeAccess.h"

@implementation NSDictionary (QYSafeAccess)

- (BOOL)hasKey:(NSString *)key {
    return [self objectForKey:key] != nil;
}

- (NSString *)stringForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
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

- (NSNumber *)numberForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if ([value isNumberClass]) {
        return (NSNumber *)value;
    }
    
    if ([value isStringClass]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)value];
    }
    
    return nil;
    
}

- (NSDecimalNumber *)desimalNumnerForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if ([value isDecimalNumber]) {
        return value;
    }
    
    if ([value isNumberClass]) {
        return [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *)value decimalValue]];
    }
    
    if ([value isStringClass]) {
        return [(NSString *)value isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:value];
    }
    
    return nil;
}

- (NSArray *)arrayForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
        return nil;
    }
    
    if ([value isArrayClass]) {
        return value;
    }
    
    return nil;
}

- (NSDictionary *)dictionaryForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
        return nil;
    }
    
    if ([value isDictionaryClass]) {
        return value;
    }
    
    return nil;
}

- (NSInteger)intergerForKey:(id)key {
    id value = [self objectForKey:key];
    
    if (value == nil || [value isNullClass]) {
        return 0;
    }
    
    if ([value isStringClass] || [value isNumberClass]) {
        return [value integerValue];
    }
    
    return 0;
}

- (NSUInteger)unsignedIntegerForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (value == nil || [value isNullClass]) {
        return 0;
    }
    
    if ([value isStringClass] || [value isNumberClass]) {
        return [value unsignedIntegerValue];
    }
    
    return 0;
}

- (BOOL)boolForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (value == nil || [value isNullClass]) {
        return NO;
    }
    
    if ([value isStringClass] || [value isNumberClass]) {
        return [value boolValue];
    }
    
    return NO;
}

- (float)floatForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
        return 0.0;
    }
    
    if ([value isNumberClass] || [value isStringClass]) {
        return [value floatValue];
    }
    
    return 0.0;
}

- (double)doubleForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
        return 0.0;
    }
    if ([value isNumberClass] || [value isStringClass]) {
        return [value doubleValue];
    }
    return 0.0;
}

- (long long)longLongForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if ([value isNumberClass] || [value isStringClass]) {
        return [value longLongValue];
    }
    
    return 0.0;
}

- (unsigned long long)unsignedlongLongForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if ([value isStringClass]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        value = [f numberFromString:(NSString *)value];
    }
    
    if ([value isNumberClass]) {
        return [value unsignedLongLongValue];
    }
    
    return 0.0;
    
}

- (int16_t)int16ForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (value == nil || [value isNullClass]) {
        return 0;
    }
    
    if ([value isNumberClass]) {
        return [value shortValue];
    }
    
    if ([value isStringClass]) {
        return [value intValue];
    }
    
    return 0;
}

- (int32_t)int32ForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
        return 0;
    }
    
    if ([value isNumberClass] || [value isStringClass]) {
        return [value intValue];
    }

    return 0;
}

- (int64_t)int64ForKey:(id)key {
    
    id value = [self objectForKey:key];
    
    if (nil == value || [value isNullClass]) {
        return 0;
    }
    
    if ([value isNumberClass] || [value isStringClass]) {
        return [value longLongValue];
    }
    
    return 0;
}

- (CGFloat)cgFloatForKey:(id)key {
    
#if CGFLOAT_IS_DOUBLE
    return [[self objectForKey:key] doubleValue];
#else
    return [[self objectForKey:key] floatValue];
#endif
}


- (CGPoint)cgPointForKey:(id)key {
    
    return CGPointFromString([self objectForKey:key]);
}

- (CGSize)cgSizeForKey:(id)key {
    return CGSizeFromString([self objectForKey:key]);
}

- (CGRect)cgRectForKey:(id)key {
    return CGRectFromString([self objectForKey:key]);
}

@end


@implementation NSMutableDictionary(QYSafeAccess)

- (void)setObj:(id)i forKey:(NSString *)key {
    
    if (nil == i) {
        return;
    }
    
    self[key] = i;
}

- (void)setString:(NSString*)i forKey:(NSString*)key {
    [self setValue:i forKey:key];
}

- (void)setBool:(BOOL)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)setInt:(int)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)setInteger:(NSInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)setCGFloat:(CGFloat)f forKey:(NSString *)key {
    self[key] = @(f);
}

- (void)setChar:(char)c forKey:(NSString *)key {
    self[key] = @(c);
}

- (void)setFloat:(float)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)setDouble:(double)i forKey:(NSString*)key {
    self[key] = @(i);
}

- (void)setLongLong:(long long)i forKey:(NSString*)key {
    self[key] = @(i);
}

- (void)setPoint:(CGPoint)o forKey:(NSString *)key {
    self[key] = NSStringFromCGPoint(o);
}

- (void)setSize:(CGSize)o forKey:(NSString *)key {
    self[key] = NSStringFromCGSize(o);
}

- (void)setRect:(CGRect)o forKey:(NSString *)key {
    self[key] = NSStringFromCGRect(o);
}

@end
