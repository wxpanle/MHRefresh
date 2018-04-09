//
//  MNetworkHelper.m
//  MHRefresh
//
//  Created by developer on 2017/10/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkHelper.h"

@implementation MNetworkHelper

+ (void)analysisResponsedData:(id)responsedData
                 successBlock:(MNetworkAnalysisSuccessBlock)successBlock
                 failureBlock:(MNetworkAnalysisFailBlock)failureBlock {
    
    NSInteger code = [responsedData[@"status"] integerValue];
    
    if (code >= 200 && code <= 299) {
        if (successBlock) {
            successBlock(responsedData[@"data"]);
        }
    } else {
        if (failureBlock) {
            failureBlock(responsedData[@"errors"], [responsedData[@"code"] integerValue]);
        }
    }
}

@end
