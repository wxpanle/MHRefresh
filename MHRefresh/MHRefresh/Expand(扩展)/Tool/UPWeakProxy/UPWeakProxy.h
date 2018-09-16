//
//  UPWeakProxy.h
//  Up
//
//  Created by panle on 2018/4/10.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UPWeakProxy : NSProxy

@property (nonatomic, weak, readonly, nullable) id target;

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
