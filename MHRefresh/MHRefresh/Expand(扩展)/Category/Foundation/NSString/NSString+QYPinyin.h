//
//  NSString+QYPinyin.h
//  MHRefresh
//
//  Created by developer on 2017/9/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QYPinyin)

- (NSString *)pinyinWithPhoneticSymbol;

- (NSString *)pinyin;

- (NSArray *)pinyinArray;

- (NSString *)pinyinWithoutBlank;

- (NSArray *)pinyinInitialsArray;

- (NSString *)pinyinInitialsString;

@end
