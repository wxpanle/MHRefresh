//
//  MNetworkConfig.h
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNetRequestHeader.h"

@class AFSecurityPolicy;

@interface MNetworkConfig : NSObject

/** request base url, Nullable */
@property (nonatomic, copy, readonly) NSString *baseUrl;

/** cdnurl default is empty string */
@property (nonatomic, copy, readonly) NSString *cdnUrl;

/** debug log info when YES */
@property (nonatomic, assign) BOOL debugLogEnabled;

/** url session configuartion */
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;

/** url security policy */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedConfig;

- (void)configWithBaseUrl:(NSString *)baseUrl andCDNUrl:(NSString *)cdnUrl;

@end
