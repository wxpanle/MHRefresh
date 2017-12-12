//
//  NSObject+QYClassIdentify.m
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSObject+QYClassIdentify.h"

#ifdef QYClassIdentify//(Class)
#error 宏定义出错 尝试其它宏定义
#else
#define QYClassIdentify(Class) [self isKindOfClass:[Class class]]
#endif

@implementation NSObject (QYClassIdentify)

- (BOOL)isNullClass {
    return QYClassIdentify(NSNull);
}

- (BOOL)isStringClass {
    return QYClassIdentify(NSString);
}

- (BOOL)isNumberClass {
    return QYClassIdentify(NSNumber);
}

- (BOOL)isDecimalNumber {
    return QYClassIdentify(NSDecimalNumber);
}

- (BOOL)isArrayClass {
    return QYClassIdentify(NSArray);
}

- (BOOL)isDictionaryClass {
    return QYClassIdentify(NSDictionary);
}

@end
