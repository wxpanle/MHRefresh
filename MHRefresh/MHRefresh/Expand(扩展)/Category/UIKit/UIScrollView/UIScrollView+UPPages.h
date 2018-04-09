//
//  UIScrollView+UPPages.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UPPages)

- (NSInteger)pages;
- (NSInteger)currentPage;
- (CGFloat)scrollPercent;

- (CGFloat)pagesY;
- (CGFloat)pagesX;
- (CGFloat)currentPageY;
- (CGFloat)currentPageX;
- (void) setPageY:(CGFloat)page;
- (void) setPageX:(CGFloat)page;
- (void) setPageY:(CGFloat)page animated:(BOOL)animated;
- (void) setPageX:(CGFloat)page animated:(BOOL)animated;

@end
