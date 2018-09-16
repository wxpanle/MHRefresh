//
//  QYTextLayoutManager.m
//  MHRefresh
//
//  Created by panle on 2018/9/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYTextLayoutManager.h"
#import <CommonCrypto/CommonCrypto.h>

@interface UIFont (QYTextLayout)

- (NSString *)qy_textLayoutString;
@end

@implementation UIFont (QYTextLayout)

- (NSString *)qy_textLayoutString {
    return [NSString stringWithFormat:@"%@ %@ %@", self.fontName, self.familyName, @(self.pointSize).stringValue];
}

@end

@interface NSString (QYTextLayout)

- (NSString *)qy_MD5String;

@end

@implementation NSString (QYTextLayout)

- (NSString *)qy_MD5String {
    
    const char *md5Str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5Str, (CC_LONG)strlen(md5Str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

#pragma mark - QYTextLayoutManager

@interface QYTextLayoutManager ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation QYTextLayoutManager

+ (instancetype)qy_textLayoutManager {
    
    static dispatch_once_t onceToken;
    static QYTextLayoutManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[QYTextLayoutManager alloc] init];
        manager.cache = [[NSCache alloc] init];
    });
    return manager;
}

+ (void)qy_cacheTextLayout:(QYTextLayout *)textLayout text:(NSString *)text font:(UIFont *)font {
    [[self qy_textLayoutManager] qy_cacheTextLayout:textLayout text:text font:font limitSize:CGSizeZero];
}

+ (void)qy_cacheTextLayout:(QYTextLayout *)textLayout text:(NSString *)text font:(UIFont *)font limitSize:(CGSize)size {
    [[self qy_textLayoutManager] qy_cacheTextLayout:textLayout text:text font:font limitSize:size];
}

- (void)qy_cacheTextLayout:(QYTextLayout *)textLayout text:(NSString *)text font:(UIFont *)font limitSize:(CGSize)size {
    
    if (!textLayout) {
        return;
    }
    
    NSString *key = [self p_cacheKeyWithText:text font:font size:size];
    [_cache setObject:textLayout forKey:key];
}

+ (nullable QYTextLayout *)qy_textLayoutWithText:(NSString *)text font:(UIFont *)font {
    return [[self qy_textLayoutManager] qy_textLayoutWithText:text font:font limitSize:CGSizeZero];
}

+ (nullable QYTextLayout *)qy_textLayoutWithText:(NSString *)text font:(UIFont *)font limitSize:(CGSize)size {
    return [[self qy_textLayoutManager] qy_textLayoutWithText:text font:font limitSize:size];
}

- (nullable QYTextLayout *)qy_textLayoutWithText:(NSString *)text font:(UIFont *)font limitSize:(CGSize)size {
    
    NSString *key = [self p_cacheKeyWithText:text font:font size:size];
    return [_cache objectForKey:key];
}


#pragma mark - init

- (NSString *)p_cacheKeyWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size {
    
    NSString *p_text = text.length == 0 ? @"" : text;
    UIFont *p_font = font == nil ? [self p_font] : font;
    return [[p_text stringByAppendingString:[p_font qy_textLayoutString]] stringByAppendingString:NSStringFromCGSize(size)];
}

- (UIFont *)p_font {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    });
    return font;
}


@end
