//
//  MNetworkOperationProtocol.h
//  MHRefresh
//
//  Created by developer on 2017/12/21.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef MNetworkOperationProtocol_h
#define MNetworkOperationProtocol_h

#ifdef __OBJC__

@class MNetworkBaseRequest;

@protocol MNetworkFinishOperationProtocol <NSObject>

- (void)networkRequestFinish:(MNetworkBaseRequest *)request;

@end

#endif


#endif /* MNetworkOperationProtocol_h */
