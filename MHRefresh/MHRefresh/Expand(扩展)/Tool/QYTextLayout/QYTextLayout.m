//
//  QYTextLayout.m
//  MHRefresh
//
//  Created by panle on 2018/9/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYTextLayout.h"

@interface QYTextLayout ()

@property (nonatomic, assign, readwrite) CGFloat qy_textWidth;

@property (nonatomic, assign, readwrite) CGFloat qy_textHeight;

@end

@implementation QYTextLayout

- (CGSize)qy_textLayoutSize {
    return CGSizeMake(_qy_textWidth, _qy_textHeight);
}

+ (instancetype)qy_textLayoutWithSize:(CGSize)size {
    return [self qy_textLayoutWithWidth:size.width height:size.height];
}

+ (instancetype)qy_textLayoutWithWidth:(CGFloat)width height:(CGFloat)height {
    return [[self alloc] initWithTextWidth:width height:height];
}

+ (instancetype)qy_textLayoutWithWidth:(CGFloat)width {
    return [self qy_textLayoutWithWidth:width height:0];
}

+ (instancetype)qy_textLayoutWithHeight:(CGFloat)height {
    return [self qy_textLayoutWithWidth:0 height:height];
}

- (instancetype)initWithTextWidth:(CGFloat)width height:(CGFloat)height {
    if (self = [super init]) {
        _qy_textWidth = width;
        _qy_textHeight = height;
    }
    return self;
}

@end
