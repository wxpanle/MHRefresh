//
//  QYMultiSelectTableViewCell.h
//  MHRefresh
//
//  Created by panle on 2018/1/22.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYMultiSelectTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat editViewWidth;

@property (nonatomic, strong) UIView *editView;


- (void)startEditAnimation;

- (void)endEditAnimation;

@end
