//
//  YXAnnotationViewController.h
//  Annotation
//
//  Created by zyx on 2017/4/28.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXAnnotationViewController;

@protocol YXAnnotationViewControllerDelegate <NSObject>

- (void)yxAnnotationViewController:(YXAnnotationViewController *)vc didAnnotatedWithNewImage:(UIImage *)annotatedImage originImage:(UIImage *)originImage;

- (void)yxAnnotationViewControllerCancelAnnotatedImage:(YXAnnotationViewController *)vc;

@end

@interface YXAnnotationViewController : UIViewController

@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, weak) id<YXAnnotationViewControllerDelegate> delegate;

@end
