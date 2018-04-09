//
//  QYObject.h
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYObject_h
#define QYObject_h

#include <stdio.h>

typedef struct Object {
    int retainCount;
}Object;

//宏定义方法 方便书写
#define OBJECTRETAIN(obj) objectRetain((Object*)obj)
#define OBJECTRELEASE(obj) objectRelease((Object*)obj)
#define GETRETAINCOUNT(obj) getRetainCount((Object*)obj)

void objectRetain(Object *obj);
void objectRelease(Object *obj);
int getRetainCount(Object *obj);

#endif /* QYObject_h */
