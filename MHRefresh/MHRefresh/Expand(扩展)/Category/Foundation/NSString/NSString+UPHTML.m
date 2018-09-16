//
//  NSString+UPHTML.m
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSString+UPHTML.h"
#import "NSCharacterSet+UPHTML.h"

static NSString *const HTMLStringSign = @"<!DOCTYPE html>";
static NSString *const TextTag = @"{$text}";
static NSString *const ImageTag = @"{$img_url}";
static NSString *const FontSize = @"{$font-size}";

@implementation NSString (UPHTML)

- (nullable NSArray *)getImageNameArray {
    
    NSMutableArray *imageSrcArray = [NSMutableArray array];
    
    if (nil == self) {
        return imageSrcArray;
    }
    
    NSArray *resultArray = [[NSString getHTMLStringExpression] matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    for (NSTextCheckingResult *result in resultArray) {
        NSString *subString = [self substringWithRange:result.range];
        NSString *imageName = [subString handleHTMLImgElement];
        if ([imageName length]) {
            if ([imageName hasPrefix:UPQiNiuHttpsLink]) {
                imageName = [imageName substringFromIndex:UPQiNiuHttpsLink.length];
                [imageSrcArray addObject:imageName];
            }
        }
    }
    
    return imageSrcArray;
}

- (NSString *)handleHTMLImgElement {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.charactersToBeSkipped = nil;
    
    NSCharacterSet *whiteCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *quoteCharacterSet = [NSCharacterSet quoteCharacterSet];
    
    [scanner scanString:@"<img" intoString:NULL];
    [scanner scanCharactersFromSet:whiteCharacterSet intoString:NULL];
    [scanner scanString:@"src" intoString:NULL];
    [scanner scanCharactersFromSet:whiteCharacterSet intoString:NULL];
    [scanner scanString:@"=" intoString:NULL];
    [scanner scanCharactersFromSet:whiteCharacterSet intoString:NULL];
    
    NSString *quote = nil;
    NSString *imageName = nil;
    [scanner scanCharactersFromSet:quoteCharacterSet intoString:&quote];
    
    if (quote) {
        [scanner scanUpToString:quote intoString:&imageName];
    }
    
    return imageName;
}

- (BOOL)isHTMLString {
    
    if (nil == self) {
        return NO;
    }
    
    return [self hasPrefix:HTMLStringSign];
}

- (BOOL)isHTMLStringOfDiyCard {
    
    static dispatch_once_t predicate;
    static NSCharacterSet *tagCharacterSet = nil;
    dispatch_once(&predicate, ^{
        tagCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    });
    
    if (!self.length) {
        return NO;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    NSString *prefix = nil;
    NSString *suffix = nil;
    BOOL isHtml = NO;
    
    if (![scanner scanString:@"<" intoString:NULL]) {
        return NO;
    }
    
    if (![scanner scanCharactersFromSet:tagCharacterSet intoString:&prefix]) {
        return NO;
    }
    
    if (!prefix.length) {
        return NO;
    }
    
    if (![scanner scanUpToString:@"<" intoString:NULL]) {
        return NO;
    }
    
    while (![scanner isAtEnd]) {
        if (![scanner scanString:@"<" intoString:NULL]) {
            scanner.scanLocation++;
            continue;
        }
        
        if ([scanner scanString:@"/" intoString:NULL]) {
            if ([scanner scanCharactersFromSet:tagCharacterSet intoString:&suffix]) {
                if ([suffix isEqualToString:prefix]) {
                    isHtml = YES;
                    break;
                }
            }
        }
        
        [scanner scanUpToString:@">" intoString:NULL];
    }
    
    return isHtml;
}

- (nullable NSString *)clearHtmlTag {
    
    static NSRegularExpression *regularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    NSString *string = [regularExpretion stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return string;
}

- (NSString *)addHtmlDOCTYPE {
    return [NSString stringWithFormat:@"%@%@%@", [NSString getHtmlPrefix], self, [NSString getHtmlSuffix]];
}

+ (NSRegularExpression *)getHTMLStringExpression {
    
    static NSRegularExpression *regularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [[NSRegularExpression alloc] initWithPattern:[self getHTMLRegularExpressionPattern] options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return regularExpression;
}

+ (NSString *)getHTMLRegularExpressionPattern {
    return @"<(img|IMG)[^<>]*>";
}

+ (UIFont *)getCombinationFont:(NSString *)string {
    
    UIFont *font = nil;
    
    if (string.length >= 60) {
        font = [UIFont systemFontOfSize:17.0];
    } else if (string.length >= 24) {
        font = [UIFont systemFontOfSize:20.0];
    } else {
        font = [UIFont systemFontOfSize:24.0];
    }
    
    return font;
}

#pragma mark card html
+ (NSString *)getCombinationHtmlAudio {
    return [NSString stringWithFormat:@"%@%@%@", [self getHtmlPrefix], [self getHtmlAudioTemplate], [self getHtmlSuffix]];
}

+ (NSString *)getCombinationHtmlText:(NSString * _Nonnull)text {
    return [NSString stringWithFormat:@"%@%@%@", [self getHtmlPrefix], [self getHtmlText:text], [self getHtmlSuffix]];
}

+ (NSString *)getCombinationHtmlImage:(NSString * _Nonnull)image {
    return [NSString stringWithFormat:@"%@%@%@", [self getHtmlPrefix], [self getHtmlImage:image], [self getHtmlSuffix]];
}

+ (NSString *)getCombinationHtmlImage:(NSString * _Nonnull)image andText:(NSString * _Nonnull)text {
    return [NSString stringWithFormat:@"%@%@%@", [self getHtmlPrefix], [self getHtmlImage:image andText:text], [self getHtmlSuffix]];
}

+ (NSString *)getHtmlImage:(NSString *)image {
    NSString *tempImage = [image copy];
    tempImage = [NSString stringWithFormat:@"%@%@", UPQiNiuHttpsLink                                                                                                                                                                                                                                                                                                                                                                                                                , tempImage];
    NSString *imageTemplate = [self getHtmlImageTemplate];
    return [imageTemplate stringByReplacingOccurrencesOfString:ImageTag withString:tempImage];
}

+ (NSString *)getHtmlText:(NSString *)text {
    NSString *tempText = [text copy];
    tempText = [self handleNewLine:tempText];
    NSString *textTemplate = [self getHtmlTextTemplate];
    NSString *font_size = [self getFontSizeText:text];
    NSString *result = [textTemplate stringByReplacingOccurrencesOfString:TextTag withString:tempText];
    result = [result stringByReplacingOccurrencesOfString:FontSize withString:font_size];
    return result;
}

+ (NSString *)getHtmlImage:(NSString *)image andText:(NSString *)text {
    NSString *tempImage = [image copy];
    NSString *tempText = [text copy];
    tempText = [self handleNewLine:tempText];
    tempImage = [NSString stringWithFormat:@"%@%@", UPQiNiuHttpsLink, tempImage];
    NSString *font_size = [self getFontSizeText:text];
    NSString *imageAndTextTemplate = [self getHtmlImageAndTextTemplate];
    imageAndTextTemplate = [imageAndTextTemplate stringByReplacingOccurrencesOfString:ImageTag withString:tempImage];
    imageAndTextTemplate = [imageAndTextTemplate stringByReplacingOccurrencesOfString:TextTag  withString:tempText];
    imageAndTextTemplate = [imageAndTextTemplate stringByReplacingOccurrencesOfString:FontSize withString:font_size];
    return imageAndTextTemplate;
}

+ (NSString *)handleNewLine:(NSString *)text {
    NSString *tempText = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br/>"];
    tempText = [tempText stringByReplacingOccurrencesOfString:@"\r" withString:@"<br/>"];
    tempText = [tempText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    return tempText;
}

+ (NSString *)getFontSizeText:(NSString *)text {
    NSString *font_size = nil;
    if (text.length >= 60) {
        font_size = @"small-text";
    } else if (text.length >= 24) {
        font_size = @"medium-text";
    } else {
        font_size = @"big-text";
    }
    return font_size;
}

+ (NSString *)getHtmlPrefix {
    return @"<!DOCTYPE html><html><head><meta http-equiv='content-type' content='text/html;charset=utf-8'><meta name='viewport' content='width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no;'><meta name='format-detection' content='telephone=no'><style type='text/css'>html,body{height:100%; width:100%; margin:0;padding:0;word-break:break-all;word-wrap:break-word;}img,video {height:100%;width:100%;}.height-half {min-height:48vh;width:100%;display:flex;justify-content:center;align-items:center;}.height-full {min-height:100vh;width:100%;display:flex;justify-content:center;align-items:center;}.img-height-half {height:48vh;width:100%;display:flex;justify-content:center;align-items:center;}.img-height-full {height:100vh;width:100%;display:flex;justify-content:center;align-items:center;}.big-text {font-size: 24px;line-height: 35px;}.medium-text {font-size: 20px;line-height: 30px;}.small-text {font-size: 17px;line-height: 28px;}</style></head><body><div style=\"margin:0 10px\">";
}

+ (NSString *)getHtmlSuffix {
    return @"</div></body></html>";
}

+ (NSString *)getHtmlAudioTemplate {
    return @"<div class=\"img-height-full\" style=\"background-color:green\"><img src=\"https://oiijtsooa.qnssl.com/audio_animation.png\" style=\"height:20vh;width:auto\"/></div>";
}

+ (NSString *)getHtmlTextTemplate {
    return  @"<div class=\"height-full {$font-size}\"><p>{$text}</p></div>";
}

+ (NSString *)getHtmlImageTemplate {
    return @"<div class=\"img-height-full\"><img src=\"{$img_url}\" style=\"object-fit:contain;\"/></div>";
}

+ (NSString *)getHtmlImageAndTextTemplate {
    return @"<div class=\"img-height-half\" style=\"background-color:#F0F0F0\"><img src=\"{$img_url}\" style=\"object-fit:contain;\"/></div><div class=\"height-half {$font-size}\"><p>{$text}</p></div>";
}


@end
