//
//  UIView+QYNib.h
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QYNib)

+ (UINib *)loadNib;

+ (UINib *)loadNibName:(NSString *)name;

+ (UINib *)loadNibName:(NSString *)name bundle:(NSBundle *)bundle;

+ (instancetype)loadInstanceFromNib;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)name;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)name owner:(id)owner;

+ (instancetype)loadInstanceFromNibWithName:(NSString *)name owner:(id)owner bundle:(NSBundle *)bundle;

@end
