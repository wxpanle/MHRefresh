//
//  QYPeople.h
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYPeople_h
#define QYPeople_h

#include <stdio.h>
#include "QYString.h"
#include "QYInteger.h"

typedef struct People {
    int retainCount;
    String *name;
    Integer *age;
} People;

People *newPeople(String *name, Integer *age);
String *getName(People *people);
Integer *getAge(People *people);

#endif /* QYPeople_h */
