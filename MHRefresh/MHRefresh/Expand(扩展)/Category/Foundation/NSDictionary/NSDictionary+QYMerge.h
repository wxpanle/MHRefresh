//
//  NSDictionary+QYMerge.h
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QYMerge)

+ (NSDictionary *)dictionaryByMerge:(NSDictionary *)dictionary withOtherDictionary:(NSDictionary *)otherDictionary;

- (NSDictionary *)dictionaryByMergeWithOtherDictionary:(NSDictionary *)otherDictionary;

@end
