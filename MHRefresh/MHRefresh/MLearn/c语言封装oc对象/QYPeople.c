//
//  QYPeople.c
//  MHRefresh
//
//  Created by developer on 2017/11/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#include "QYPeople.h"
#include <stdlib.h>
#include "QYObject.h"

People *newPeople(String *name, Integer *age) {
    People *people = malloc(sizeof(People));
    OBJECTRETAIN((Object *)people);
    people->name = name;
    people->age = age;
    return people;
}

String *getName(People *people) {
    return people -> name;
}

Integer *getAge(People *people) {
    return people -> age;
}
