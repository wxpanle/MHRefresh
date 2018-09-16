//
//  NSString+UPExtension.m
//  Up
//
//  Created by panle on 2018/5/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSString+UPExtension.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "UPPhoneHelp.h"
//#import "UPPhoneNumberModel.h"

@implementation NSString (UPExtension)

#pragma mark - ===== audio duration =====
+ (NSString *)stringForAudioDuration:(NSTimeInterval)time {
    NSInteger min = time / 60;
    NSInteger second = time - min * 60;
    NSString *result = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)second];
    return result;
}

#pragma mark - ===== nickname =====

- (NSString *)clearNickNameSpecialCharacter {
    
    return [self replaceSpecialCharacterWithText:@"?"];
}

- (NSString *)replaceSpecialCharacterWithText:(NSString *)replaceText {
    
    if (!self.length) {
        return self;
    }
    
    if (nil == replaceText) {
        replaceText = @"?";
    }
    
    NSMutableString *originStr = [NSMutableString stringWithString:self];
    
    NSString *string = [[self p_nickNameReplaceRegularExpression] stringByReplacingMatchesInString:originStr options:0 range:NSMakeRange(0, self.length) withTemplate:replaceText];
    
    return string;
}

- (BOOL)nickNameIsLegal {
    
    if (!self.length) {
        return NO;
    }
    
    NSArray *array = [[self p_nickNameRegularExpression] matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (array.count == 1) {
        NSTextCheckingResult *result = array.firstObject;
        NSString *tempString = [self substringWithRange:result.range];
        if (tempString.length == self.length) {
            return YES;
        }
    }
    
    return NO;
}

///------------------------------
/// @name phonenUmber
///------------------------------

- (NSString *)showPhoneNumber {
    
    return nil;
    
//    UPPhoneNumberModel *model = [UPPhoneHelp up_modelWithIntegerPhoneNumber:self];
//
//    if (model.stringSuffix.length <= 8) {
//        return [model.stringSuffix stringByReplacingCharactersInRange:NSMakeRange(model.stringSuffix.length - 1, 1) withString:@"*"];
//    }
//
//    NSString *numberString = [model.stringSuffix stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//    return numberString;
}

- (NSRegularExpression *)p_nickNameReplaceRegularExpression {
    static NSRegularExpression *regularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ //
        regularExpression = [[NSRegularExpression alloc] initWithPattern:@"([^\u4e00-\u9fa5A-Za-z0-9_]{1})" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return regularExpression;
}

- (NSRegularExpression *)p_nickNameRegularExpression {
    static NSRegularExpression *regularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[\u4e00-\u9fa5A-Za-z0-9_]*$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return regularExpression;
}

#pragma mark - ===== sha256 =====

- (NSString *)sha256String {
    if (self == nil) {
        return nil;
    }
    NSData *encodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[32];
    CC_SHA256(encodeData.bytes, (CC_LONG)encodeData.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:32 * 2];
    for (int i = 0; i < 32; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

#pragma mark - ===== email =====

- (BOOL)isEmail {
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"^[A-Za-z0-9_]{6,18}@[A-Za-z0-9.]+\\.[A-Za-z]{2,3}$" options:0 error:nil];
    NSArray *array = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    BOOL flag = [self hasSuffix:@".com"] || [self hasSuffix:@".cn"] || [self hasSuffix:@".net"];
    return array.count && flag;
}

#pragma mark - ===== code =====
- (BOOL)isVerifyCode {
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]{6}$" options:0 error:nil];
    NSArray *array = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return array.count != 0 ? YES : NO;
}


#pragma mark - ===== password =====
- (BOOL)isPasswordEnable {
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"^[A-Za-z0-9_./]{6,16}$" options:0 error:nil];
    NSArray *array = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return array.count != 0;
}


#pragma mark - signature

- (BOOL)isSpaceComposition {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

@end
