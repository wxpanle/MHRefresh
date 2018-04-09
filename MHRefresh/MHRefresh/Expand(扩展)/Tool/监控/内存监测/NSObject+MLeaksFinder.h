//
//  NSObject+MLeaksFinder.h
//  MLeaksFinder
//
//  Created by zyx on 16/7/7.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMonitor.h"

#if M_MONITOR_ENABLED
extern const void *kTestDealloc;

@interface NSObject (MLeaksFinder)


- (BOOL)testDealloc;

- (NSArray *)viewStack;
- (void)setViewStack:(NSArray *)viewStack;

/**
 *  swizzle SEL
 *
 */
+ (void)swizzleSelector:(SEL)selector1 withSelector:(SEL)selector2;

@end

#endif
