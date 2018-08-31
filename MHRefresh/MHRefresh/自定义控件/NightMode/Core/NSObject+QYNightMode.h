//
//  NSObject+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYNightCore.h"

@interface NSObject (QYNightMode)

@property (nonatomic, readonly) NSMutableDictionary *qy_nightModeDictionary;

@property (nonatomic, readonly) QYNightMode qy_nightNode;

@property (nonatomic, readonly, getter=isNightMode) BOOL nightMode;

/**
 激活夜间模式
 */
- (void)qy_activeNightMode;

/**
 切换夜间模式
 */
- (void)qy_switchNightMode;


/**
 获取保存的key值

 @param sel sel
 @param mode mode
 @return NSString *
 */
- (NSString *)qy_saveKeyWithSEL:(SEL)sel nightMode:(QYNightMode)mode;

/**
 获取保存的key值
 
 @param string string
 @param mode mode
 @return NSString *
 */
- (NSString *)qy_saveKeyWithString:(NSString *)string nightMode:(QYNightMode)mode;

@end
