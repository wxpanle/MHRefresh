//
//  YXButton.h
//  Annotation
//
//  Created by zyx on 2017/5/2.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXButtonLayout) {
    YXButtonLayoutImageTop,
};

@interface YXButton : UIButton

@property (nonatomic, assign) YXButtonLayout layout;

@end
