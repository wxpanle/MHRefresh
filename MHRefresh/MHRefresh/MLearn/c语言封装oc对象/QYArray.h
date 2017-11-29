//
//  QYArray.h
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYArray_h
#define QYArray_h

#include <stdio.h>
#include "QYPeople.h"
#include "QYObject.h"

typedef Object * AnyObject;

typedef struct Array {
    int length;
    int capacity;
    AnyObject *value;
} Array;

Array *newArray(void);

//添加数组元素
void addElement(Array *array, AnyObject value);

//删除
Array * removeIndexAt(Array *array, int index);

//插入
Array * insertIndexAt(Array *array, AnyObject value, int index);

//查找
AnyObject getValueIndexAt(Array *array, int index);

//获取数组长度
int getArrayLength(Array *array);

//销毁
void destoryArray(Array *array);

//打印
void printfArray(Array *arr);



#endif /* QYArray_h */
