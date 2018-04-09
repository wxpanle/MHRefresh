//
//  QYInteger.h
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYInteger_h
#define QYInteger_h

#include <stdio.h>

typedef struct Integer {
    int retainCount;
    int value;
} Integer;

Integer * newInteger(int value);

int getIntegerValue(Integer *ins);


#endif /* QYInteger_h */
