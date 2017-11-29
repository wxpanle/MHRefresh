//
//  QYInteger.c
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#include "QYInteger.h"
#include "QYObject.h"
#include <stdlib.h>

Integer * newInteger(int value) {
    Integer *new = malloc(sizeof(Integer));
    OBJECTRETAIN(new);
    new->value = value;
    return new;
}

int getIntegerValue(Integer *ins) {
    return ins -> value;
}
