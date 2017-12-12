//
//  NSObject+QYClassIdentify.h
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QYClassIdentify)

- (BOOL)isNullClass;

- (BOOL)isStringClass;

- (BOOL)isNumberClass;

- (BOOL)isDecimalNumber;

- (BOOL)isArrayClass;

- (BOOL)isDictionaryClass;

@end
