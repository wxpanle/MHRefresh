//
//  QYPhotoBrowerView.h
//  MHRefresh
//
//  Created by panle on 2018/8/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYPhotoBrowerView : UIView

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (void)setImageWithImageKey:(NSString *)imageKey placeholderImage:(UIImage *)placeholder;

@end
