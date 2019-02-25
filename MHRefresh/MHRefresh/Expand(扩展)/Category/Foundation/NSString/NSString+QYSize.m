//
//  NSString+QYSize.m
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+QYSize.h"

#import <CoreText/CoreText.h>

static inline CGSize CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(CTFramesetterRef framesetter, NSAttributedString *attributedString, CGSize size, NSUInteger numberOfLines) {
    
    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedString length]);
    CGSize constraints = CGSizeMake(size.width, CGFLOAT_MAX);
    
    if (numberOfLines == 1) {
        constraints = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    } else if (numberOfLines > 0) {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.f, 0.f, constraints.width, CGFLOAT_MAX));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (CFArrayGetCount(lines)) {
            NSInteger lastVisibleLineIndex = MIN((CFIndex)numberOfLines - 1, CFArrayGetCount(lines) - 1);
            CTLineRef lastVisiableLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangeToLayout = CTLineGetStringRange(lastVisiableLine);
            rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
        }
        
        CFRelease(frame);
        CGPathRelease(path);
    }
    
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);
    return CGSizeMake(CGFloat_ceil(suggestedSize.width), CGFloat_ceil(suggestedSize.height) + 2.0);
}

@implementation NSString (QYSize)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    
    return [self sizeWithFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width numberLines:(NSInteger)numberLines {
    return [self sizeWithFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX) numberLines:numberLines].height;
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    
    return [self sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, height)].width;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    
    return [self sizeWithFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width numberLines:(NSInteger)numberLines {
    return [self sizeWithFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX) numberLines:numberLines];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    
    return [self sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, height)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size {
    
    __autoreleasing NSString *tempString = [self copy];
    
    if (nil == tempString || !tempString.length) {
        tempString = @"字符串为空";
    }
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect frame = [tempString boundingRectWithSize:size options:options attributes:[self p_attributesDictionaryWithFont:font] context:nil];
    return CGSizeMake(CGFloat_ceil(frame.size.width), CGFloat_ceil(frame.size.height) + 2.0);
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size numberLines:(NSInteger)numberLines {
    
    NSAttributedString *attributeString = [self p_attributedStringWithFont:font];
    if (!attributeString) {
        return CGSizeZero;
    }
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributeString);
    CGSize calculatedSize = CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(framesetter, attributeString, size, numberLines);
    CFRelease(framesetter);
    return calculatedSize;
}

+ (NSString *)singleString {
    return LocalizedString(@"ui.singleHeight.title");
}

+ (CGFloat)singleHeightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    
    NSString *string = [self singleString];
    
    return [string heightWithFont:font constrainedToWidth:CGFLOAT_MAX];
}

- (NSDictionary *)p_attributesDictionaryWithFont:(UIFont *)font {
    if (nil == font) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    return @{NSFontAttributeName: font,
             NSParagraphStyleAttributeName: paragraph};
}

- (NSAttributedString *)p_attributedStringWithFont:(UIFont *)font {
    return [[NSAttributedString alloc] initWithString:self attributes:[self p_attributesDictionaryWithFont:font]];
}

@end


@implementation NSAttributedString (QYSize)

- (CGSize)sizeWithConstrainedSize:(CGSize)size {
    return [self sizeWithConstrainedSize:size numberLines:0];
}

- (CGSize)sizeWithConstrainedSize:(CGSize)size numberLines:(NSInteger)numberLines {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    CGSize calculatedSize = CTFramesetterSuggestFrameSizeForAttributedStringWithConstraints(framesetter, self, size, 0);
    CFRelease(framesetter);
    return calculatedSize;
}

- (CGFloat)heightWithConstrainedWidth:(CGFloat)width {
    return [self heightWithConstrainedWidth:width numberLines:0];
}

- (CGFloat)heightWithConstrainedWidth:(CGFloat)width numberLines:(NSInteger)numberLines {
    return [self sizeWithConstrainedSize:CGSizeMake(width, CGFLOAT_MAX) numberLines:numberLines].height;
}

@end
