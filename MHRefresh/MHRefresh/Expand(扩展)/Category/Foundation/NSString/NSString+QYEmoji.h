//
//  NSString+QYEmoji.h
//  MHRefresh
//
//  Created by developer on 2017/9/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QYEmoji)

- (BOOL)isIncludingEmoji;

+ (BOOL)isIncludingEmoji:(NSString *)text;

+ (NSString *)replaceEmojiWithText:(NSString *)text replaceText:(NSString *)replaceText;

+ (NSString *)clearEmojiWithText:(NSString *)text;

- (NSString *)clearEmoji;

- (NSString *)replaceEmojiWithText:(NSString *)text;

- (NSString *)stringByReplacingEmojiCheatCodesWithUnicode;

- (NSString *)stringByReplacingEmojiUnicodeWithCheatCodes;

@end
