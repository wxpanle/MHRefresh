//
//  UIView+SMExtension.h
//  SeeMovies
//
//  Created by developer on 2017/8/17.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SMExtension)

@property (assign, nonatomic) CGFloat sm_x;
@property (assign, nonatomic) CGFloat sm_y;
@property (assign, nonatomic) CGFloat sm_width;
@property (assign, nonatomic) CGFloat sm_height;
@property (assign, nonatomic) CGSize sm_size;
@property (assign, nonatomic) CGFloat sm_centerX;
@property (assign, nonatomic) CGFloat sm_centerY;
@property (nonatomic, assign) CGPoint sm_origin;

@end
