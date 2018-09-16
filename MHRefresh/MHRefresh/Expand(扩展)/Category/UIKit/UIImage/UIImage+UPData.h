//
//  UIImage+UPData.h
//  Up
//
//  Created by panle on 2018/4/10.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UPData)

+ (instancetype)up_imageWithData:(NSData *)data;

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength;

- (NSData *)data;

- (UIImage *)imageWithLimitSize:(CGSize)size;

@end
