//
//  QYPreviewWindow.m
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "QYPreviewWindow.h"

@implementation QYPreviewWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelNormal + 1;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = NO;
    }
    return self;
}

- (void)dealloc {
    DLog(@"%@ dealloc", self);
}

@end
