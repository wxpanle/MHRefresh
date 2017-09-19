//
//  NSString+QYSize.m
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+QYSize.h"

@implementation NSString (QYSize)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {

    return [self sizeWithFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX)].height;
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    
    return [self sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, height)].width;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    
    return [self sizeWithFont:font constrainedSize:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {

    return [self sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, height)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size {
    
    if (nil == font) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    __autoreleasing NSString *tempString = [self copy];
    
    if (nil == tempString || !tempString.length) {
        tempString = @"字符串为空";
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraph};
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect frame = [tempString boundingRectWithSize:size options:options attributes:attributes context:nil];
    
    return CGSizeMake(ceil(frame.size.width), ceil(frame.size.height));
}

@end
