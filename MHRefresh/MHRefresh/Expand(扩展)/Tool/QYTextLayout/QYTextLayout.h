//
//  QYTextLayout.h
//  MHRefresh
//
//  Created by panle on 2018/9/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYTextLayout : NSObject

@property (nonatomic, assign, readonly) CGFloat qy_textWidth;

@property (nonatomic, assign, readonly) CGFloat qy_textHeight;

- (CGSize)qy_textLayoutSize;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)qy_textLayoutWithSize:(CGSize)size;

+ (instancetype)qy_textLayoutWithWidth:(CGFloat)width height:(CGFloat)height;

+ (instancetype)qy_textLayoutWithWidth:(CGFloat)width;

+ (instancetype)qy_textLayoutWithHeight:(CGFloat)height;

@end
