//
//  NSURLProtocol+MWebKitSupport.h
//  Memory
//
//  Created by developer on 17/4/12.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtocol (MWebKitSupport)

+ (void)registerWebKitSupportScheme:(NSString *)scheme;

+ (void)unregisterWebKitSupportScheme:(NSString *)scheme;

@end
