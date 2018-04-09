//
//  QYObject.c
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#include "QYObject.h"
#include <stdlib.h>

void objectRetain(Object *obj) {
    obj -> retainCount += 1;
}

void objectRelease(Object *obj) {
    obj -> retainCount -= 1;
    if (obj -> retainCount <= 0) {
        free(obj);
    }
}

int getRetainCount(Object *obj) {
    return obj -> retainCount;
}
