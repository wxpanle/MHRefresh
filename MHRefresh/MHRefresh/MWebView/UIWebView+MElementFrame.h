//
//  UIWebView+MElementFrame.h
//  Memory
//
//  Created by developer on 17/5/8.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (MElementFrame)

/**
 返回webView内坐标点对应的html元素相对于当前屏幕的位置
 
 @param point touch点
 @return 元素的frame
 */
- (CGRect)elementFrameWithPoint:(CGPoint)point;

@end
