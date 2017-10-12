//
//  ChessResultModel.m
//  test
//
//  Created by developer on 2017/10/10.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "ChessResultModel.h"

/*
 输出将和帅可以移动的所有范围  只能使用一个变量  a 代表将   b 代表帅
 */

/*
 输出 ab 互斥的所有条件
 
 1个8位byte存储两个位置信息
 */

#define HALF_BITS_LENGTH 4
#define MOVE_LENGTH 3
#define FULLMASK 255
#define LMASK (FULLMASK << HALF_BITS_LENGTH)
#define RMASK (FULLMASK >> HALF_BITS_LENGTH)
#define LSET(b, n) (b = ((RMASK & b) | ((n) << HALF_BITS_LENGTH)))
#define RSET(b, n) (b = ((LMASK & b) | (n)))
#define LGET(b) ((LMASK & b) >> HALF_BITS_LENGTH)
#define RGET(b) (RMASK & b)

@implementation ChessResultModel

+ (void)getChessResult {
    [self getChessResult1];
    [self getChessResult2];
    [self getChessResult3];
}
/*
 位运算的时间是最快的
 */
+ (void)getChessResult1 {
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    [self printfNewLine];
    
    unsigned char b = '\0';
    for (LSET(b, 1); LGET(b) <= MOVE_LENGTH * MOVE_LENGTH; LSET(b, LGET(b) + 1)) {
        for (RSET(b, 1); RGET(b) <= MOVE_LENGTH * MOVE_LENGTH; RSET(b, RGET(b) + 1)) {
            if (LGET(b) % MOVE_LENGTH != RGET(b) % MOVE_LENGTH) {
                NSLog(@"A = %d   b = %d", LGET(b), RGET(b));
            }
        }
    }
    
    [self printfNewLine];
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"endTime1 = %f", endTime - startTime);
#endif
}

+ (void)getChessResult2 {
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    [self printfNewLine];
    
    Byte i = 81;
    
    while (i--) {
        if (i / 9 % 3 == i % 9 % 3) {
            continue;
        }
        NSLog(@"A = %d B = %d", i / 9 + 1, i % 9 + 1);
    }
    [self printfNewLine];
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"endTime2 = %f", endTime - startTime);
#endif
}

+ (void)getChessResult3 {
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    
    [self printfNewLine];
    
    struct number {
        unsigned char a : 4;
        unsigned char b : 4;
    } i;
    
    for (i.a = 1; i.a <= 9; i.a++) {
        for (i.b = 1; i.b <= 9; i.b++) {
            if (i.a % 3 != i.b % 3) {
                NSLog(@"A = %d B = %d", i.a, i.b);
            }
        }
    }
    
    [self printfNewLine];
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"endTime3 = %f", endTime - startTime);
#endif
}

@end
