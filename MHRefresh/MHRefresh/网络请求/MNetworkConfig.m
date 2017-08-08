//
//  MNetworkConfig.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkConfig.h"
#import "AFSecurityPolicy.h"

@interface MNetworkConfig()

@end

@implementation MNetworkConfig

+ (instancetype)sharedConfig {
    static MNetworkConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        [self layoutUIInit];
    }
    return self;
}

- (void)layoutUIInit {
    _baseUrl = @"";
    _cdnUrl = @"";
    _securityPolicy = [AFSecurityPolicy defaultPolicy];
    _debugLogEnabled = NO;
    _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
}

- (void)configWithBaseUrl:(NSString *)baseUrl andCDNUrl:(NSString *)cdnUrl {
    _baseUrl = baseUrl;
    _cdnUrl = cdnUrl;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" baseUrl = %@, cdnUrl = %@", _baseUrl, _cdnUrl];
}

@end
