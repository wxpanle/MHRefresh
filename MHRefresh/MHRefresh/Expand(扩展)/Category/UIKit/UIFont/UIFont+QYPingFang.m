//
//  UIFont+QYPingFang.m
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIFont+QYPingFang.h"

@implementation UIFont (QYPingFang)

+ (instancetype)fontPingFang:(QYPingFangSC)sc size:(CGFloat)size {
    
    if (!IS_iOS_9_Later) {
        return [UIFont systemFontOfSize:size];
    }
    
    switch (sc) {
        case QYPingFangSCLight:
            return [UIFont fontWithName:@"PingFangSC-Light" size:size];
        case QYPingFangSCRegular:
            return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
        case QYPingFangSCMedium:
            return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
        case QYPingFangSCSemibold:
            return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }
}

@end
