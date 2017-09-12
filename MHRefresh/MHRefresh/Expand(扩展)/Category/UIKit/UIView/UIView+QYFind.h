//
//  UIView+QYFind.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

///-----------------------------------------------------
/// @name(https://github.com/shaojiankui/iOS-Categories)
///-----------------------------------------------------

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QYFind)

- (nullable UIView *)findSubViewWithSubViewClass:(Class)clazz;

- (nullable id)findSuperViewWithSuperViewClass:(Class)clazz;

- (BOOL)findAndResignFirstResponder;

- (nullable UIView *)findFirstResponder;

@end

NS_ASSUME_NONNULL_END
