//
//  UIView+QYDebug.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIView+QYDebug.h"
#import <objc/runtime.h>

#define Random  (double)arc4random_uniform(256) / 255
#define RandomColor [UIColor colorWithRed:Random green:Random blue:Random alpha:1.0]

@implementation UIView (QYDebug)

+ (void)load {

#ifdef DEBUG_VIEW
    Method original, swizzle;
    
    original = class_getInstanceMethod(self, @selector(initWithFrame:));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithFrame:));
    method_exchangeImplementations(original, swizzle);
    
    original = class_getInstanceMethod(self, @selector(initWithCoder:));
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithCoder:));
    method_exchangeImplementations(original, swizzle);
#endif
}

- (id)swizzled_initWithFrame:(CGRect)frame {
    
    id result = [self swizzled_initWithFrame:frame];
    
    if ([result respondsToSelector:@selector(layer)]) {
        CALayer *layer = [result layer];
        layer.borderWidth = 2.f;
        layer.borderColor = RandomColor.CGColor;
    }
    
    return result;
}

- (id)swizzled_initWithCoder:(NSCoder *)aDecoder {
    
    id result = [self swizzled_initWithCoder:aDecoder];
    
    if ([result respondsToSelector:@selector(layer)]) {
        CALayer *layer = [result layer];
        layer.borderWidth = 2.f;
        layer.borderColor = RandomColor.CGColor;
    }
    
    return result;
}

@end
