//
//  MNetworkHelper.h
//  MHRefresh
//
//  Created by developer on 2017/10/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ MNetworkAnalysisSuccessBlock) (id data);
typedef void (^ MNetworkAnalysisFailBlock) (id errors, NSInteger errorCode);

@interface MNetworkHelper : NSObject

+ (void)analysisResponsedData:(id)responsedData
                 successBlock:(MNetworkAnalysisSuccessBlock)successBlock
                 failureBlock:(MNetworkAnalysisFailBlock)failureBlock;

@end
