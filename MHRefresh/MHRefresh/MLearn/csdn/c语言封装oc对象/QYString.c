//
//  QYString.c
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#include "QYString.h"
#include <stdlib.h>
#include "QYObject.h"

String * newString(char *value) {
    String *str = malloc(sizeof(String));
    objectRetain((Object *)str);
    str->value = value;
    return str;
}

char * getStringValue(String *ins) {
    return ins -> value;
}
