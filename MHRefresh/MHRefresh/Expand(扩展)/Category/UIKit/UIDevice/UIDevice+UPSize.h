//
//  UIDevice+UPSize.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhoneSize) {
    PhoneSize3_5,           // 3'5
    PhoneSize4_0,           // 4
    PhoneSize4_7,           // 4'7
    PhoneSize5_5,           // 5'5
    PhoneSize5_8,           // 5‘8
    PhoneSize6_1,           // 6'1
    PhoneSize6_5,           // 6'5
};

@interface UIDevice (UPSize)

+ (PhoneSize)currentPhoneSize;

@end
