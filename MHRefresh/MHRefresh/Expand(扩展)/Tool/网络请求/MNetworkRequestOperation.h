//
//  MNetworkRequestOperation.h
//  MHRefresh
//
//  Created by developer on 2017/10/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetworkOperationProtocol.h"

@interface MNetworkRequestOperation : NSOperation <MNetworkFinishOperationProtocol>

- (instancetype)initWithNetworkBaseRequest:(id)request;

- (BOOL)isOperationOfDataTaskIdentifier:(NSUInteger)identifier;

@end
