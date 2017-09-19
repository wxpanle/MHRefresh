//
//  UIFont+QYTTF.h
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

///-----------------------------------------------
/// @name https://github.com/nin9tyfour/UIFont-TTF
///-----------------------------------------------

#import <UIKit/UIKit.h>

@interface UIFont (QYTTF)

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size;

+ (UIFont *)fontWithTTFAtURL:(NSURL *)URL size:(CGFloat)size;

@end
