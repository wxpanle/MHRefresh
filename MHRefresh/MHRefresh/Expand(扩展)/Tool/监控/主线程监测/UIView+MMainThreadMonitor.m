//
//  UIView+MMainThreadMonitor.m
//  Memory
//
//  Created by zyx on 16/8/2.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "UIView+MMainThreadMonitor.h"
#import <objc/runtime.h>
#import <objc/message.h>

#if M_MONITOR_ENABLED

@implementation UIView (MMainThreadMonitor)

+ (void)load
{
    [self swizzleSelector:@selector(setNeedsLayout) withSelector:@selector(m_setNeedsLayout)];
    [self swizzleSelector:@selector(setNeedsDisplayInRect:) withSelector:@selector(m_setNeedsDisplayInRect:)];
    [self swizzleSelector:@selector(setNeedsDisplay) withSelector:@selector(m_setNeedsDisplay)];
}


#pragma mark -

- (void)m_setNeedsLayout
{
    [self m_setNeedsLayout];
    [self assert];
}

- (void)m_setNeedsDisplay
{
    [self m_setNeedsDisplay];
    [self assert];

}

- (void)m_setNeedsDisplayInRect:(CGRect)rect
{
    [self m_setNeedsDisplayInRect:rect];
    [self assert];

}

- (void)assert
{
    NSAssert([[NSThread currentThread] isMainThread], @"当前不是在主线程操作UI");
}

#pragma mark -

+ (void)swizzleSelector:(SEL)selector1 withSelector:(SEL)selector2
{
    Class cla = [self class];
    
    Method method1 = class_getInstanceMethod(cla, selector1);
    Method method2 = class_getInstanceMethod(cla, selector2);
    
    IMP IMP1 = class_getMethodImplementation(cla, selector1);
    IMP IMP2 = class_getMethodImplementation(cla, selector2);
    
    BOOL res = class_addMethod(cla, selector1, IMP2, method_getTypeEncoding(method2));
    
    if (res) {
        class_replaceMethod(cla, selector2, IMP1, method_getTypeEncoding(method1));
    } else {
        method_exchangeImplementations(method1, method2);
    }
}

@end
#endif
