//
//  QYTextLayoutManager.h
//  MHRefresh
//
//  Created by panle on 2018/9/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYTextLayout.h"
#import "NSObject+QYTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYTextLayoutManager : NSObject

+ (void)qy_cacheTextLayout:(QYTextLayout *)textLayout text:(NSString *)text font:(UIFont *)font limitSize:(CGSize)size;

+ (void)qy_cacheTextLayout:(QYTextLayout *)textLayout text:(NSString *)text font:(UIFont *)font;

+ (nullable QYTextLayout *)qy_textLayoutWithText:(NSString *)text font:(UIFont *)font limitSize:(CGSize)size;

+ (nullable QYTextLayout *)qy_textLayoutWithText:(NSString *)text font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
