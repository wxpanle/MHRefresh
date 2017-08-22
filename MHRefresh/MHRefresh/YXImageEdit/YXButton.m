//
//  YXButton.m
//  Annotation
//
//  Created by zyx on 2017/5/2.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXButton.h"

@implementation YXButton


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (!self.imageView.image || !self.titleLabel.text) {
        return;
    }
    
    CGSize imageSize = self.imageView.image.size;
    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];

    switch (_layout) {
        case YXButtonLayoutImageTop: {
           
            CGFloat imageV = labelSize.height / 2;
            CGFloat titleV = imageSize.height / 2;
            
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageV, labelSize.width / 2, imageV, -labelSize.width / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(titleV, -imageSize.width / 2, -titleV, imageSize.width / 2);
            
            break;
        }
            
        default:
            break;
    }
    
    
}

@end
