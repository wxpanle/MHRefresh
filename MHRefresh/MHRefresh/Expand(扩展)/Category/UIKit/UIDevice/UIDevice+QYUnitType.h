//
//  UIDevice+QYUnitType.h
//  MHRefresh
//
//  Created by developer on 2017/9/25.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhoneModel) {
    
    iPhoneUnknown,   //未知
    iPhone1,
    iPhone3G,
    iPhone3GS,
    iPhone4,
    iPhone4s,
    iPhone5,
    iPhone5s,
    iPhone5c,
    iPhoneSE,
    iPhone6,
    iPhone6p,
    iPhone6s,
    iPhone6sp,
    iPhone7,
    iPhone7p,
    iPhone8,
    iPhone8p,
    iPhoneX,
    
    iPhoneSimulator,
    OtheriPhone,
    
    iPodUnknown, //iPod 未知
    iPodTouch1,
    iPodTouch2,
    iPodTouch3,
    iPodTouch4,
    iPodTouch5,
    iPodTouch6,
    
    iPadUnknown, //iPad 未知
    iPad1,
    iPad2,
    iPad3,
    iPad4,
    iPadAir,
    iPadAir2,
    iPadMini1,
    iPadMini2,
    iPadMini3,
    iPadMini4,
    iPadPro9Point7,
    iPadPro12Point9,
    
    AppleTVUnknow,
    AppleTV2,
    AppleTV3,
    AppleTV4,
};

@interface UIDevice (QYUnitType)

+ (PhoneModel)currentPhoneModel;

+ (NSString *)getCurentPhoneModelString;

@end
