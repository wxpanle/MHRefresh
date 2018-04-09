//
//  NSObject+MLeaksFinder.m
//  MLeaksFinder
//
//  Created by zyx on 16/7/7.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "NSObject+MLeaksFinder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

#if M_MONITOR_ENABLED
static const void *kViewStack = &kViewStack;
const void *kTestDealloc = &kTestDealloc;

@implementation NSObject (MLeaksFinder)


- (BOOL)testDealloc
{
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showAlert];
    });
    return YES;
}

- (void)showAlert
{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:LocalizedString(@"检测到内存泄露")  message:LocalizedString(@"测试用,可忽略") preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *element in [self viewStack]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:element style:UIAlertActionStyleDefault handler:nil];
        [alertVc addAction:action];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:true completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    });
    
}

#pragma mark - 

- (NSArray *)viewStack
{
    NSArray *res = objc_getAssociatedObject(self, &kViewStack);
    return res ? res : @[NSStringFromClass([self class])];
}

- (void)setViewStack:(NSArray *)viewStack
{
    objc_setAssociatedObject(self, &kViewStack, viewStack, OBJC_ASSOCIATION_RETAIN);
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
