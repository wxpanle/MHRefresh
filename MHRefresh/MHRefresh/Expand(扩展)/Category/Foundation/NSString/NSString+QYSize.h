//
//  NSString+QYSize.h
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QYSize)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width numberLines:(NSInteger)numberLines;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width numberLines:(NSInteger)numberLines;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size numberLines:(NSInteger)numberLines;

+ (CGFloat)singleHeightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

+ (NSString *)singleString;

@end


@interface NSAttributedString (QYSize)

- (CGSize)sizeWithConstrainedSize:(CGSize)size;
- (CGSize)sizeWithConstrainedSize:(CGSize)size numberLines:(NSInteger)numberLines;
- (CGFloat)heightWithConstrainedWidth:(CGFloat)width;
- (CGFloat)heightWithConstrainedWidth:(CGFloat)width numberLines:(NSInteger)numberLines;

@end
