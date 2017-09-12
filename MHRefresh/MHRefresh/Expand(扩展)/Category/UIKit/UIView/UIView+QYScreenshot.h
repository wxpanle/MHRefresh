//
//  UIView+QYScreenshot.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QYScreenshot)

- (UIImage *)screenshot;

- (UIImage *)screenshot:(CGFloat)maxWidth;

@end
