//
//  QYMemoryCache.m
//  MHRefresh
//
//  Created by panle on 2017/12/28.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "QYMemoryCache.h"
#import <pthread.h>

static const NSTimeInterval kActiveMemorySeconds = 5 * 60;

@interface QYLinkMapNode : NSObject

@property (nonatomic, strong) QYLinkMapNode *prev;
@property (nonatomic, strong) QYLinkMapNode *next;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) id key;
@property (nonatomic, assign) NSTimeInterval lastCallTime;

@property (nonatomic, assign) NSUInteger cost;

@end

@implementation QYLinkMapNode
@end

@interface QYLinkMap : NSObject

@property (nonatomic, strong) NSMutableDictionary *mapDic;
@property (nonatomic, strong) QYLinkMapNode *head;
@property (nonatomic, strong) QYLinkMapNode *tail;
@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, assign) NSUInteger totalCost;

- (void)insertNodeAtHead:(QYLinkMapNode *)node;
- (void)bringNodeToHead:(QYLinkMapNode *)node;
- (void)removeNode:(QYLinkMapNode *)node;
- (QYLinkMapNode *)removeTailNode;
- (void)removeAll;

@end

@implementation QYLinkMap

- (instancetype)init {
    if (self = [super init]) {
        _mapDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        _totalCost = 0;
        _totalCount = 0;
    }
    return self;
}

- (void)insertNodeAtHead:(QYLinkMapNode *)node {
    //save key
    [_mapDic setObject:node forKey:node.key];
    _totalCount++;
    _totalCost += node.cost;
    
    if (_head) {
        node.next = _head;
        _head.prev = node;
        _head = node;
    } else {
        _head = _tail = node;
    }
}

- (void)bringNodeToHead:(QYLinkMapNode *)node {
    if (_head == node) {
        return;
    }
    
    if (_tail == node) {
        _tail = node.prev;
        _tail.next = nil;
    } else {
        node.next.prev = node.prev;
        node.prev.next = node.next;
    }

    node.next = _head;
    node.prev = nil;
    _head.prev = node;
    _head = node;
}

- (void)removeNode:(QYLinkMapNode *)node {
    [self removeNoreFormMapDicWithkey:node.key];
    _totalCount--;
    _totalCost -= node.cost;
    if (node.next) {
        node.next.prev = node.prev;
    }
    
    if (node.prev) {
        node.prev.next = node.next;
    }
    
    if (_head == node) {
        _head = node.next;
    }
    
    if (_tail == node) {
        _tail = node.prev;
    }
}

- (QYLinkMapNode *)removeTailNode {
    if (nil == _tail) {
        return nil;
    }
    
    QYLinkMapNode *tailNode = _tail;
    [self removeNoreFormMapDicWithkey:tailNode.key];
    _totalCost -= tailNode.cost;
    _totalCount--;
    if (_head == _tail) {
        _head = _tail = nil;
    } else {
        _tail = tailNode.prev;
        _tail.next = nil;
    }
    
    return nil;
}

- (void)removeAll {
    _totalCost = 0;
    _totalCount = 0;
    _head = nil;
    _tail = nil;
    [_mapDic removeAllObjects];
}

#pragma mark - ========== help ==========

- (void)removeNoreFormMapDicWithkey:(NSString *)key {
    [_mapDic removeObjectForKey:key];
}


#pragma mark - ========== dealloc ==========

- (void)dealloc {
    DLOG_DEALLOC
}


@end

static inline dispatch_queue_t QYMemoryCacehReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

static inline dispatch_queue_t QYHandleDataQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.cache.memory", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

@interface QYMemoryCache()

@property (nonatomic, assign) pthread_mutex_t lock;

@property (nonatomic, strong) QYLinkMap *map;

@end


@implementation QYMemoryCache

#pragma mark - ========== init ==========

- (instancetype)init {
    
    if (self = [super init]) {
        
        //init lock
        pthread_mutex_init(&_lock, NULL);
        _map = [[QYLinkMap alloc] init];
        // DISPATCH_QUEUE_SERIAL
        
        _countLimit = 0;
        _costLimit = 0;
        _clearUselessDataInterval = 10.0;
        _activeMemorySeconds = kActiveMemorySeconds;
        
        _shouldClearUselessData = YES;
        _shouldRemoveAllObjectsOnMemoryWarning = YES;
        _shouldRemoveAllObjectsWhenEnteringBackground = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterABckgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}


#pragma mark - ========== public ==========

- (BOOL)containsObjectForKey:(id)key {
    if (!key) {
        return NO;
    }
    
    [self mLock];
    BOOL contains = [_map.mapDic objectForKey:key];
    [self mUnLock];
    return contains;
}

- (nullable id)objectForKey:(id)key {
    if (!key) {
        return nil;
    }
    
    [self mLock];
    QYLinkMapNode *node = [_map.mapDic objectForKey:key];
    if (node) {
        node.lastCallTime = [[NSDate date] timeIntervalSince1970];
        [_map bringNodeToHead:node];
    }
    [self mUnLock];
    return node ? node.value : nil;
}

- (void)setObject:(nullable id)object forKey:(id)key {
    [self setObject:object forKey:key withCost:0];
}

- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost {
    
    if (!key) {
        return;
    }
    
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    [self mLock];
    
    QYLinkMapNode *node = [_map.mapDic objectForKey:key];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    if (node) {
        _map.totalCost -= node.cost;
        _map.totalCost += cost;
        node.cost = cost;
        node.lastCallTime = currentTime;
        node.value = object;
        [_map bringNodeToHead:node];
    } else {
        node = [[QYLinkMapNode alloc] init];
        node.cost = cost;
        node.lastCallTime = currentTime;
        node.key = key;
        node.value = object;
        [_map insertNodeAtHead:node];
    }
    
    if (_costLimit > 0 && _map.totalCost > _costLimit) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(_queue == nil ? QYHandleDataQueue() : _queue, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return ;
            }
            //清除cost
            [strongSelf clearToCost:strongSelf.costLimit];
        });
    }
    
    if (_countLimit > 0 && _map.totalCount > _countLimit) {
        QYLinkMapNode *tailNode = [_map removeTailNode];
        dispatch_async(QYMemoryCacehReleaseQueue(), ^{
            [tailNode class];
        });
    }
    
    [self mUnLock];
}

- (void)removeObjectForKey:(id)key {
    
    if (!key) {
        return;
    }
    [self mLock];
    QYLinkMapNode *node = [_map.mapDic objectForKey:key];
    if (node) {
        [_map removeNode:node];
        dispatch_async(QYMemoryCacehReleaseQueue(), ^{
            [node class];
        });
    }
    [self mUnLock];
}

- (void)removeAllObjects {
    [self mLock];
    [_map removeAll];
    [self mUnLock];
}


#pragma mark - ========== private ==========

- (void)clearRecursively {
    
    if (!_shouldClearUselessData) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_clearUselessDataInterval * NSEC_PER_SEC)), QYMemoryCacehReleaseQueue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return ;
        }
        [strongSelf clearInBackground];
        [strongSelf clearRecursively];
    });
}

- (void)clearInBackground {
    dispatch_async(_queue == nil ? QYHandleDataQueue() : _queue, ^{
        [self clearToCost:self.costLimit];
        [self clearToCount:self.countLimit];
        [self clearToTimeLimit:self.activeMemorySeconds];
    });
}

- (void)clearToCost:(NSUInteger)costLimit {
    
    BOOL finish = NO;
    [self mLock];
    if (costLimit == 0) {
        [_map removeAll];
        finish = YES;
    } if (_map.totalCost <= costLimit) {
        finish = YES;
    }
    [self mUnLock];
    if (finish) {
        return;
    }
    
    NSMutableArray *holder = [NSMutableArray array];
    
    while (!finish) {
        if (pthread_mutex_trylock(&_lock) == 0) {
            if (_map.totalCost <= costLimit) {
                QYLinkMapNode *node = [_map removeTailNode];
                if (node) {
                    [holder addObject:node];
                }
            } else {
                finish = YES;
            }
            [self mUnLock];
        } else {
            usleep(10 * 1000);
        }
    }
    
    if (holder.count) {
        dispatch_async(QYMemoryCacehReleaseQueue(), ^{
            [holder count];
        });
    }
}

- (void)clearToCount:(NSUInteger)countLimit {
    BOOL finish = NO;
    [self mLock];
    if (countLimit == 0) {
        [_map removeAll];
        finish = YES;
    } else if (_map.totalCount <= countLimit) {
        finish = YES;
    }
    [self mUnLock];
    if (finish) {
        return;
    }
    
    NSMutableArray *holder = [NSMutableArray array];
    while (!finish) {
        if (pthread_mutex_trylock(&_lock) == 0) {
            if (_map.totalCount > countLimit) {
                QYLinkMapNode *node = [_map removeTailNode];
                if (node) {
                    [holder addObject:node];
                }
            } else {
                finish = YES;
            }
            [self mUnLock];
        } else {
            usleep(10 * 1000);
        }
    }
    
    if (holder.count) {
        dispatch_async(QYMemoryCacehReleaseQueue(), ^{
            [holder count];
        });
    }
}

- (void)clearToTimeLimit:(NSUInteger)timeLimit {
    
    BOOL finish = NO;
    //如果时间到  但是并没有超过限制  不清除缓存
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    [self mLock];
    if (timeLimit <= 0) {
        [_map removeAll];
        finish = YES;
    } else if (!_map.tail ||
               (now - _map.tail.lastCallTime) <= timeLimit ||
               _map.totalCost <= _costLimit) {
        finish = YES;
    }
    [self mUnLock];
    if (finish) {
        return;
    }
    
    NSMutableArray *holder = [NSMutableArray array];
    while (!finish) {
        if (pthread_mutex_trylock(&_lock) == 0) {
            if (_map.totalCost <= _costLimit / 2.0) { //默认小于一半时不再清理
                finish = YES;
            } else if (_map.tail && (now - _map.tail.lastCallTime) > timeLimit) {
                QYLinkMapNode *node = [_map removeTailNode];
                if (node) {
                    [holder addObject:node];
                }
            } else {
                finish = YES;
            }
            [self mUnLock];
        } else {
            usleep(10 * 1000);
        }
    }
    
    if (holder.count) {
        dispatch_async(QYMemoryCacehReleaseQueue(), ^{
            [holder count];
        });
    }
}


#pragma mark - ========== notifiction ==========

- (void)appDidReceiveMemoryWarningNotification {
    
    if (![self shouldRemoveAllObjectsOnMemoryWarning]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue == nil ? QYHandleDataQueue() : _queue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf removeAllObjects];
    });
}

- (void)appDidEnterABckgroundNotification {
    
    if (!self.shouldRemoveAllObjectsWhenEnteringBackground) {
        return;
    }
    
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    
    if (!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    
    UIApplication *applecation = [UIApplication performSelector:@selector(sharedApplication)];
    
    __block UIBackgroundTaskIdentifier bgTask = [applecation beginBackgroundTaskWithExpirationHandler:^{
        [applecation endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue == nil ? QYHandleDataQueue() : _queue, ^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf clearToTimeLimit:strongSelf.activeMemorySeconds];
    });
}


#pragma mark - ========== getter ==========

- (NSUInteger)totalCount {
    [self mLock];
    NSUInteger count = _map.totalCount;
    [self mUnLock];
    return count;
}

- (NSUInteger)totalCost {
    [self mLock];
    NSUInteger cost = [_map totalCost];
    [self mUnLock];
    return cost;
}


#pragma mark - ========== help ==========

- (void)mLock {
   pthread_mutex_lock(&_lock);
}

- (void)mUnLock {
    pthread_mutex_unlock(&_lock);
}

#pragma mark - ========== dealloc ==========

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_map removeAll];
    pthread_mutex_destroy(&_lock);
    DLOG_DEALLOC
}


@end
