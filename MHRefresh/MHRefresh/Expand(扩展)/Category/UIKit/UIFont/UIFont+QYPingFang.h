//
//  UIFont+QYPingFang.h
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QYPingFangSC) {
    QYPingFangSCLight,
    QYPingFangSCRegular,
    QYPingFangSCSemibold,
    QYPingFangSCMedium,
};

@interface UIFont (QYPingFang)

+ (instancetype)fontPingFang:(QYPingFangSC)pingFangSc size:(CGFloat)size;

@end
