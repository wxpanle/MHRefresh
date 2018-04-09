//
//  MPhotoCollectionViewCell.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MPhotoCollectionViewCell.h"
#import "MPhotoModel.h"
#import "UIView+SMExtension.h"

@interface MPhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *gifImageView;

@end

@implementation MPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.gifImageView];
}

- (void)layoutUIOfSelf {
    self.contentMode = UIViewContentModeCenter;
    self.clipsToBounds = YES;
}

#pragma mark - public
- (void)updateWithPhotoModel:(MPhotoModel *)photoModel {
    self.imageView.image = photoModel.image;
    self.gifImageView.hidden = photoModel.type == MPhotoTypeGIF ? NO : YES;
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIImageView *)gifImageView {
    if (nil == _gifImageView) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.sm_height - 20 - 5, 35, 20)];
        _gifImageView.image = [UIImage imageNamed:@"gif_flag"];
        _gifImageView.hidden = YES;
    }
    return _gifImageView;
}

@end
