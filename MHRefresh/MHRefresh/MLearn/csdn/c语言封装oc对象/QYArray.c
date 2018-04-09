//
//  QYArray.c
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#include "QYArray.h"
#include <string.h>
#include <stdlib.h>
#include <assert.h>

static AnyObject *allocMemoryByCapacity(Array *arr) {
    return malloc(sizeof(People *) * arr->capacity);
}

Array *newArray(void) {
    Array *array = malloc(sizeof(Array));
    array->length = 0;
    array->capacity = 5;
    array->value = allocMemoryByCapacity(array);
    return array;
}

//添加数组元素
void addElement(Array *array, AnyObject value) {
    if (array->length >= array->capacity) {
        array->capacity *= 2;
        AnyObject *oldValue = array->value;
        memcpy(array->value, oldValue, array->length * sizeof(AnyObject));
        free(oldValue);
    }
    
    OBJECTRETAIN(value);
    array -> value[array->length] = value;
    array->length++;
}

//删除
Array * removeIndexAt(Array *array, int index) {
    assert(index >= 0 && index < array->length);
    
    OBJECTRELEASE(getValueIndexAt(array, index));
    
    array->length--;
    
    for (int i = index; i < array ->length; i++) {
        array->value[i] = array->value[i + 1];
    }
    
    return array;
}

//插入
Array * insertIndexAt(Array *array, AnyObject value, int index) {
    if (array->length >= array->capacity) {
        array->capacity *= 2;
        AnyObject *oldValue = array->value;
        memcpy(array->value, oldValue, array->length * sizeof(AnyObject));
        free(oldValue);
    }
    array->length++;
    
    for (int i = 1; i <= array->length - index; i++) {
        array->value[array ->length - 1] = array->value[array->length - i - 1];
    }
    
    array->value[index] = value;
    
    OBJECTRETAIN(value);
    return array;
}

//查找
AnyObject getValueIndexAt(Array *array, int index) {
    assert(index >= 0 && index < array->length);
    return array->value[index];
}

//获取数组长度
int getArrayLength(Array *array) {
    return array->length;
}

//销毁
void destoryArray(Array *array) {
    free(array->value);
    free(array);
    printf("数组被销毁");
}

void printfArray(Array *arr) {
    for (int i = 0; i < arr->length; i++) {
        People *people = (People *)getValueIndexAt(arr, i);
        printf("位置 - %d 姓名 - %s 年龄 %d \n", i, getStringValue(getName(people)), getIntegerValue(getAge(people)));
    }
}


//打印
void printfArray(Array *arr);
