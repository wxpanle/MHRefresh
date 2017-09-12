//
//  UIView+QYFind.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIView+QYFind.h"

@implementation UIView (QYFind)

- (nullable id)findSubViewWithSubViewClass:(Class)clazz {
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:clazz]) {
            return subView;
        }
    }
    
    return nil;
}

- (nullable id)findSuperViewWithSuperViewClass:(Class)clazz {
    
    if (nil == self) {
        return nil;
    }
    
    if (nil == self.superview) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    }
    
    return [self.superview findSuperViewWithSuperViewClass:clazz];
}

- (BOOL)findAndResignFirstResponder {
    
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    
    for (UIView *view in self.subviews) {
        if ([view findAndResignFirstResponder]) {
            return YES;
        }
    }
    
    return NO;
}

- (nullable UIView *)findFirstResponder {
    
    if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]]) && self.isFirstResponder) {
        return self;
    }
    
    for (UIView *view in self.subviews) {
        if (nil != [view findFirstResponder]) {
            return view;
        }
    }
    
    return nil;
}

@end
