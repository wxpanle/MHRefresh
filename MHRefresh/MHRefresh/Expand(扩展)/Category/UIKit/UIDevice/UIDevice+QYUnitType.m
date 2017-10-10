//
//  UIDevice+QYUnitType.m
//  MHRefresh
//
//  Created by developer on 2017/9/25.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIDevice+QYUnitType.h"
#import <sys/utsname.h>

@implementation UIDevice (QYUnitType)

static NSString *devicePlatform = nil;

+ (PhoneModel)currentPhoneModel
{
    static PhoneModel model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // http://www.jianshu.com/p/02bba9419df8
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        
        
        if ([platform isEqualToString:@"iPhone1,1"]) {
            model = iPhone1;
        } else if ([platform isEqualToString:@"iPhone1,2"]) {
            model = iPhone3G;
        } else if ([platform isEqualToString:@"iPhone2,1"]) {
            model = iPhone3GS;
        } else if ([platform isEqualToString:@"iPhone3,1"] || [platform isEqualToString:@"iPhone3,2"] || [platform isEqualToString:@"iPhone3,3"]) {
            model = iPhone4;
        } else if ([platform isEqualToString:@"iPhone4,1"]) {
            model = iPhone4s;
        } else if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"]) {
            model = iPhone5;
        } else if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"]) {
            model = iPhone5c;
        } else if ([platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"]) {
            model = iPhone5s;
        } else if ([platform isEqualToString:@"iPhone7,1"] ) {
            model = iPhone6p;
        } else if ([platform isEqualToString:@"iPhone7,2"] ) {
            model = iPhone6;
        } else if ([platform isEqualToString:@"iPhone8,1"] ) {
            model = iPhone6s;
        } else if ([platform isEqualToString:@"iPhone8,2"] ) {
            model = iPhone6sp;
        } else if ([platform isEqualToString:@"iPhone8,4"] ) {
            model = iPhoneSE;
        } else if ([platform isEqualToString:@"iPhone9,1"] || [platform isEqualToString:@"iPhone9,3"]) {
            model = iPhone7;
        } else if ([platform isEqualToString:@"iPhone9,2"] || [platform isEqualToString:@"iPhone9,4"]) {
            model = iPhone7p;
        } else if ([platform isEqualToString:@"iPhone10,1"] || [platform isEqualToString:@"iPhone10,4"]) {
            model = iPhone8;
        } else if ([platform isEqualToString:@"iPhone10,2"] || [platform isEqualToString:@"iPhone10,5"]) {
            model = iPhone8p;
        } else if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) {
            model = iPhoneX;
        } else if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
            model = iPhoneSimulator;
        } else if ([platform isEqualToString:@"iPod1,1"]) {
            model = iPodTouch1;
        } else if ([platform isEqualToString:@"iPod2,1"]) {
            model = iPodTouch2;
        } else if ([platform isEqualToString:@"iPod3,1"]) {
            model = iPodTouch3;
        } else if ([platform isEqualToString:@"iPod4,1"]) {
            model = iPodTouch4;
        } else if ([platform isEqualToString:@"iPod5,1"]) {
            model = iPodTouch5;
        } else if ([platform isEqualToString:@"iPod7,1"]) {
            model = iPodTouch6;
        } else if ([platform isEqualToString:@"iPad1,1"]) {
            model = iPad1;
        } else if ([platform isEqualToString:@"iPad2,1"] || [platform isEqualToString:@"iPad2,2"] || [platform isEqualToString:@"iPad2,3"] || [platform isEqualToString:@"iPad2,4"]) {
            model = iPad2;
        } else if ([platform isEqualToString:@"iPad3,1"] || [platform isEqualToString:@"iPad3,2"] || [platform isEqualToString:@"iPad3,3"]) {
            model = iPad3;
        } else if ([platform isEqualToString:@"iPad3,4"] || [platform isEqualToString:@"iPad3,5"] || [platform isEqualToString:@"iPad3,6"]) {
            model = iPad4;
        } else if ([platform isEqualToString:@"iPad2,5"] || [platform isEqualToString:@"iPad2,6"] || [platform isEqualToString:@"iPad2,7"]) {
            model = iPadMini1;
        } else if ([platform isEqualToString:@"iPad4,4"] || [platform isEqualToString:@"iPad4,5"] || [platform isEqualToString:@"iPad4,6"]) {
            model = iPadMini2;
        } else if ([platform isEqualToString:@"iPad4,7"] || [platform isEqualToString:@"iPad4,8"] || [platform isEqualToString:@"iPad4,9"]) {
            model = iPadMini3;
        } else if ([platform isEqualToString:@"iPad5,1"] || [platform isEqualToString:@"iPad5,2"]) {
            model = iPadMini4;
        } else if ([platform isEqualToString:@"iPad4,1"] || [platform isEqualToString:@"iPad4,2"] || [platform isEqualToString:@"iPad4,3"]) {
            model = iPadAir;
        } else if ([platform isEqualToString:@"iPad5,3"] || [platform isEqualToString:@"iPad5,4"]) {
            model = iPadAir2;
        } else if ([platform isEqualToString:@"iPad6,3"] || [platform isEqualToString:@"iPad6,4"]) {
            model = iPadPro9Point7;
        } else if ([platform isEqualToString:@"iPad6,7"] || [platform isEqualToString:@"iPad6,8"]) {
            model = iPadPro12Point9;
        } else if ([platform isEqualToString:@"AppleTV2,1"]) {
            model = AppleTV2;
        } else if ([platform isEqualToString:@"AppleTV3,1"] || [platform isEqualToString:@"AppleTV3,2"]) {
            model = AppleTV3;
        } else if ([platform isEqualToString:@"AppleTV5,3"]) {
            model = AppleTV4;
        } else {
            
            devicePlatform = platform;
            
            if ([platform rangeOfString:@"iPhone"].location != NSNotFound) {
                model = iPhoneUnknown;
            } else if ([platform rangeOfString:@"iPod"].location != NSNotFound) {
                model = iPodUnknown;
            } else if ([platform rangeOfString:@"iPad"].location != NSNotFound) {
                model = iPadUnknown;
            } else if ([platform rangeOfString:@"AppleTV"].location != NSNotFound) {
                model = AppleTVUnknow;
            } else {
                model = OtheriPhone;
            }
        }
    });
    return model;
}


+ (NSString *)getCurentPhoneModelString {
    
    PhoneModel model = [self currentPhoneModel];
    
    if (model == iPhoneUnknown) {
        return devicePlatform.length != 0 ? devicePlatform : @"iPhone unkonow";
    } else if (model == iPhone1) {
        return @"iPhone1";
    } else if (model == iPhone3G) {
        return @"iPhone 3G";
    } else if (model == iPhone3GS) {
        return @"iPhone 3GS";
    } if (model == iPhone4) {
        return @"iPhone4";
    } else if (model == iPhone4s) {
        return @"iPhone4s";
    } else if (model == iPhone5) {
        return @"iPhone5";
    } else if (model == iPhone5s) {
        return @"iPhone5s";
    } else if (model == iPhone5c) {
        return @"iPhone5c";
    } else if (model == iPhoneSE) {
        return @"iPhoneSE";
    } else if (model == iPhone6) {
        return @"iPhone6";
    } else if (model == iPhone6p) {
        return @"iPhone6p";
    } else if (model == iPhone6s) {
        return @"iPhone6s";
    } else if (model == iPhone6sp) {
        return @"iPhone6sp";
    } else if (model == iPhone7) {
        return @"iPhone7";
    } else if (model == iPhone7p) {
        return @"iPhone7p";
    } else if (model == iPhone8) {
        return @"iPhone8";
    } else if (model == iPhone8p) {
        return @"iPhone9";
    } else if (model == iPhoneX) {
        return @"iPhoneX";
    } else if (model == iPodUnknown) {
        return devicePlatform.length != 0 ? devicePlatform : @"iPod Unknow";
    } else if (model == iPodTouch1) {
        return @"iPod Touch 1";
    } else if (model == iPodTouch2) {
        return @"iPod Touch 2";
    } else if (model == iPodTouch3) {
        return @"iPod Touch 3";
    } else if (model == iPodTouch4) {
        return @"iPod Touch 4";
    } else if (model == iPodTouch5) {
        return @"iPod Touch 5";
    } else if (model == iPodTouch6) {
        return @"iPod Touch 6";
    } else if (model == iPadUnknown) {
        return devicePlatform.length != 0 ? devicePlatform : @"iPad Unknow";
    } else if (model == iPad1) {
        return @"iPad 1";
    } else if (model == iPad2) {
        return @"iPad 2";
    } else if (model == iPad3) {
        return @"iPad 3";
    } else if (model == iPad4) {
        return @"iPad 4";
    } else if (model == iPadAir) {
        return @"iPad Air";
    } else if (model == iPadAir2) {
        return @"iPad Air 2";
    } else if (model == iPadMini1) {
        return @"iPad Mini 1";
    } else if (model == iPadMini2) {
        return @"iPad Mini 2";
    } else if (model == iPadMini3) {
        return @"iPad Mini 3";
    } else if (model == iPadMini4) {
        return @"iPad Mini 4";
    } else if (model == iPadPro9Point7) {
        return @"iPad Pro 9 7";
    } else if (model == iPadPro12Point9) {
        return @"iPad Pro 12 9";
    } else if (model == AppleTVUnknow) {
        return devicePlatform.length != 0 ? devicePlatform : @"AppleTV Unknow";
    } else if (model == AppleTV2) {
        return @"AppleTV2";
    } else if (model == AppleTV3) {
        return @"AppleTV3";
    } else if (model == AppleTV4) {
        return @"AppleTV4";
    } else if (model == iPhoneSimulator) {
        return @"iPhoneSimulator";
    } else if (model == OtheriPhone) {
        return @"OtheriPhone";
    }
    return @"未知";
}

@end
