//
//  NSObject+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "NSObject+QYNightMode.h"
#import <objc/runtime.h>
#import "QYNightModeManager.h"

static char kNightModeObservesKey;
static char kNightModeDictionaryKey;

@implementation NSObject (QYNightMode)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
        Method newMethod = class_getInstanceMethod([self class], @selector(qy_dealloc));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)qy_dealloc {
    if ([objc_getAssociatedObject(self, &kNightModeObservesKey) boolValue]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:QYNightModeSwitchNotification
                                                      object:nil];
    }
    
    [self qy_dealloc];
}

- (void)qy_activeNightMode {
    
    if ([objc_getAssociatedObject(self, &kNightModeObservesKey) boolValue]) {
        return;
    }
    
    objc_setAssociatedObject(self, &kNightModeObservesKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(qy_switchNightMode) name:QYNightModeSwitchNotification
                                               object:nil];
}

- (void)qy_switchNightMode {}

- (NSString *)qy_saveKeyWithSEL:(SEL)sel nightMode:(QYNightMode)mode {
    return [self qy_saveKeyWithString:NSStringFromSelector(sel) nightMode:mode];
}

- (NSString *)qy_saveKeyWithString:(NSString *)string nightMode:(QYNightMode)mode {
    return [(string.length ? string : @"") stringByAppendingString:@(mode).stringValue];
}

#pragma mark - getter

- (NSMutableDictionary *)qy_nightModeDictionary {
    
    NSMutableDictionary *resultDict = objc_getAssociatedObject(self, &kNightModeDictionaryKey);
    
    if (!resultDict) {
        resultDict = [NSMutableDictionary dictionaryWithCapacity:0];
        objc_setAssociatedObject(self, &kNightModeDictionaryKey, resultDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return resultDict;
}

- (BOOL)isNightMode {
    return self.qy_nightNode == QYNightModeNight;
}

- (QYNightModeManager *)qy_nightModeManager {
    return [QYNightModeManager qy_nightModeManager];
}

- (QYNightMode)qy_nightNode {
    return [self qy_nightModeManager].qy_nightMode;
}

@end
