//
//  NSObject+QYTextLayout.m
//  MHRefresh
//
//  Created by panle on 2018/9/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "NSObject+QYTextLayout.h"
#import <objc/runtime.h>

static char kQYTextLayoutKey;

@implementation NSObject (QYTextLayout)

- (void)setQy_textLayout:(QYTextLayout *)qy_textLayout {
    objc_setAssociatedObject(self, &kQYTextLayoutKey, qy_textLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QYTextLayout *)qy_textLayout {
    return objc_getAssociatedObject(self, &kQYTextLayoutKey);
}

@end
