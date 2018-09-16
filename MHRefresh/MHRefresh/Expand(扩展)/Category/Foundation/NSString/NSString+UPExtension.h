//
//  NSString+UPExtension.h
//  Up
//
//  Created by panle on 2018/5/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UPExtension)

///------------------------------
/// @name audio duration
///------------------------------
+ (NSString *)stringForAudioDuration:(NSTimeInterval)time;

///------------------------------
/// @name nickName
///------------------------------

/**
 使用 ‘？’代替特殊字符

 @return return value description
 */
- (NSString *)clearNickNameSpecialCharacter;
- (BOOL)nickNameIsLegal;

///------------------------------
/// @name phonenUmber
///------------------------------
- (NSString *)showPhoneNumber;


///------------------------------
/// @name sha256
///------------------------------
- (NSString *)sha256String;

///------------------------------
/// @name email
///------------------------------
- (BOOL)isEmail;

///------------------------------
/// @name code
///------------------------------
- (BOOL)isVerifyCode;

///------------------------------
/// @name password
///------------------------------

- (BOOL)isPasswordEnable;

///------------------------------
/// @name signature
///------------------------------

- (BOOL)isSpaceComposition;

@end

