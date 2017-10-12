//
//  UIImage+QYAlpha.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QYAlpha)

- (BOOL)hasAlpha;

- (UIImage *)imageWithAlpha;

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

//http://stackoverflow.com/questions/6521987/crop-uiimage-to-alpha?answertab=oldest#tab-top
- (UIImage *)trimmedBetterSize;

@end
