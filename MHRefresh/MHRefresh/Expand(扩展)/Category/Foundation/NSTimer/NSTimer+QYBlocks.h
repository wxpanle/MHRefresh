//
//  NSTimer+QYBlocks.h
//  MHRefresh
//
//  Created by developer on 2017/9/18.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ QYTimerActionBlock) ();

@interface NSTimer (QYBlocks)


/**
 重复运行

 @param timeInterval <#timeInterval description#>
 @param block <#block description#>
 @return <#return value description#>
 */
+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block;

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block repeats:(BOOL)repeats;

+ (id)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block;

+ (id)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block repeats:(BOOL)repeats;

@end
