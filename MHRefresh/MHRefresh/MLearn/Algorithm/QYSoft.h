//
//  QYSoft.h
//  MHRefresh
//
//  Created by panle on 2018/9/10.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYSoft : NSObject

+ (instancetype)new NS_UNAVAILABLE;

- (void)start;

- (NSArray *)qy_softArray;

- (void)qy_insertTime;

- (void)qy_endTime;

- (void)qy_swap:(int *)nums left:(int)i right:(int)j;

- (void)qy_printf:(int *)nums count:(int)count;

@end
