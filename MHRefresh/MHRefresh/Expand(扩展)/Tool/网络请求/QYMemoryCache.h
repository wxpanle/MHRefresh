//
//  QYMemoryCache.h
//  MHRefresh
//
//  Created by panle on 2017/12/28.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYMemoryCache : NSObject

///------------------------------
/// @name cache attribute
///------------------------------

/** cache name */
@property (nonatomic, copy) NSString *name;

/** cache count */
@property (nonatomic, readonly, assign) NSUInteger totalCount;

/** cache cost*/
@property (nonatomic, readonly, assign) NSUInteger totalCost;

///------------------------------
/// @name cache Limit
///------------------------------

/** cache Limit count */
@property (nonatomic, assign) NSUInteger countLimit;

/** cache Limit cost  */
@property (nonatomic, assign) NSUInteger costLimit;

/** default YES */
@property (nonatomic, assign) BOOL shouldRemoveAllObjectsOnMemoryWarning;

/** default YES */
@property (nonatomic, assign) BOOL shouldRemoveAllObjectsWhenEnteringBackground;

/** default YES */
@property (nonatomic, assign) BOOL shouldClearUselessData;

/** default 10*/
@property (nonatomic, assign) NSTimeInterval clearUselessDataInterval;

/** default 60s * 5min = 300s clear with no use in 5min */
@property (nonatomic, assign) NSTimeInterval activeMemorySeconds;

/** clear cache queue must be serial */
@property (nonatomic, strong, nullable) dispatch_queue_t queue;

///------------------------------
/// @name Access MEthods
///------------------------------

/**
 judge is has a cache for given key

 @param key key
 @return    YES or NO
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 get cache object for given key nullable

 @param key key
 @return    nullable key
 */
- (nullable id)objectForKey:(id)key;

/**
 cache object with key

 @param object object
 @param key    key
 */
- (void)setObject:(nullable id)object forKey:(id)key;

/**
 cache object with key

 @param object object
 @param key    key
 @param cost   cost must >= 0
 */
- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost;

/**
 remove cache object

 @param key key
 */
- (void)removeObjectForKey:(id)key;

/**
 remove all objects
 */
- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
