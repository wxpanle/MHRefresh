//
//  MNetRequestHeader.h
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef MNetRequestHeader_h
#define MNetRequestHeader_h

typedef void (^MNetWorkNilBlock)(void);

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

#import "MNetworkBaseRequest.h"
#import "MNetworkDownloadRequest.h"

#endif /* MNetRequestHeader_h */
