//
//  QYKVOModel.m
//  MHRefresh
//
//  Created by panle on 2018/2/5.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYKVOModel.h"

//https://zh.wikipedia.org/wiki/Lab%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4#XYZ.E4.B8.8ECIE_L.2Aa.2Ab.2A.28CIELAB.29.E7.9A.84.E8.BD.AC.E6.8D.A2

static double inverseF(double const t);
static double D65TristimulusValues[3] = {95.047, 100.0, 108.883};

static double inverseF(double const t)
{
    return ((t > 6./29.) ?
            t*t*t :
            3.*(6./29.)*(6./29.)*(t-4./29.));
}

@implementation QYKVOModel

- (id)init {
    self = [super init];
    if (self) {
        self.lComponent = 75 + (arc4random_uniform(200) * 0.1 - 10.);
        self.aComponent = 0 + (arc4random_uniform(200) * 0.1 - 10.);
        self.bComponent = 0 + (arc4random_uniform(200) * 0.1 - 10.);
    }
    return self;
}

- (double)blueComponent {
    return D65TristimulusValues[2] * inverseF(1./116. * (self.lComponent + 16) - 1./200.*self.bComponent);
}

- (double)redComponent {
    return D65TristimulusValues[0] * inverseF(1./116. * (self.lComponent + 16));
}

- (double)greenCompenent {
    return D65TristimulusValues[1] * inverseF(1./116. * (self.lComponent + 16) + 1./500. * self.aComponent);
}

- (UIColor *)color
{
    return [UIColor colorWithRed:self.redComponent * 0.01 green:self.greenComponent * 0.01 blue:self.blueComponent * 0.01 alpha:1.];
}

+ (NSSet *)keyPathsForValuesAffectingRedComponent {
    return [NSSet setWithObject:@"lComponent"];
}

+ (NSSet *)keyPathsForValuesAffectingGreenComponent {
    return [NSSet setWithObjects:@"lComponent", @"aComponent", nil];
}

+ (NSSet *)keyPathsForValuesAffectingBlueComponent {
    return [NSSet setWithObjects:@"lComponent", @"bComponent", nil];
}

+ (NSSet *)keyPathsForValuesAffectingColor {
    return [NSSet setWithObjects:@"redComponent", @"greenComponent", @"blueComponent", nil];
}


- (void)setNilValueForKey:(NSString *)key {
    
    if ([key isEqualToString:@"height"]) {
        [self setValue:@0 forKey:key];
    } else {
        [super setNilValueForKey: key];
    }
    
}


- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    //重写value赋值方法
    
    
    
}

+ (BOOL)accessInstanceVariablesDirectly {
    //附注：Foundation 框架支持直接访问实例变量。请小心的使用这个特性。你可以去查看 +accessInstanceVariablesDirectly 的文档。这个值默认是 YES 的时候，Foundation 会按照 _<key>, _is<Key>, <key> 和 is<Key> 的顺序查找实例变量。
    return NO;
}

- (NSUInteger)countOfContacts {
    return 10;
}

@end

