//
//  QYString.h
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYString_h
#define QYString_h

#include <stdio.h>

typedef struct String {
    int retainCount;
    char *value;
} String;

String * newString(char *value);
char * getStringValue(String *ins);

#endif /* QYString_h */
