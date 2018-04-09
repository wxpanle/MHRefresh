//
//  QYPreviewImageView.m
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "QYPreviewImageView.h"
#import "QYPreviewImageHeader.h"

@interface QYPreviewImageView() <UIGestureRecognizerDelegate>

@end

@implementation QYPreviewImageView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectZero]) {
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)updateImage:(UIImage *)image isLandscape:(BOOL)isLandscape {
    
    if (nil == image) {
        return;
    }

    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat width = QY_SCREEN_W;
    
    CGFloat height = QY_SCREEN_W * image.size.height / image.size.width;
    
    CGSize imageSize = image.size;
    
    if (isLandscape) {

        if (imageSize.width > imageSize.height * 2) {
            width = QY_SCREEN_H;
            height = width * imageSize.height / imageSize.width;
        } else {
            height = QY_SCREEN_W;
            width = height * imageSize.width / imageSize.height;
        }
    }

    self.frame = CGRectMake(0, 0, width, height);
    
    self.image = image;
    
    [self setNeedsLayout];
}

@end
