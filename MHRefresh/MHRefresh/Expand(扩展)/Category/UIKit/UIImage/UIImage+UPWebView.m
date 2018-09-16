//
//  UIImage+UPWebView.m
//  Up
//
//  Created by panle on 2018/4/10.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIImage+UPWebView.h"

@implementation UIImage (UPWebView)

+ (CGRect)absoluteFrame:(CGRect)frame image:(UIImage *)image {
    
    if (!image) {
        return frame;
    }
    
    CGRect tempFrame = frame;
    
    CGFloat baseWidth = tempFrame.size.width;
    CGFloat baseHeight = tempFrame.size.height;
    CGSize size = image.size;
    
    CGFloat picWidth = size.width;
    CGFloat picHeight = size.height;
    
    if (picWidth / picHeight >= baseWidth / baseHeight) {  //上下有空余
        CGFloat realityHeight = baseWidth * picHeight / picWidth;
        CGFloat offentY = frame.origin.y + (baseHeight - realityHeight) / 2.0;
        tempFrame = CGRectMake(frame.origin.x, offentY, baseWidth, realityHeight);
    } else { //左右有空余
        CGFloat realityWidth = baseHeight * picWidth / picHeight;
        CGFloat offentX = frame.origin.x + (baseWidth - realityWidth) / 2.0;
        tempFrame = CGRectMake(offentX, frame.origin.y, realityWidth, baseHeight);
    }
    return tempFrame;
    
}

- (CGRect)absoluteFrame:(CGRect)frame {
    return [[self class] absoluteFrame:frame image:self];
}

@end
