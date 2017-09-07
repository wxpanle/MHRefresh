//
//  MPhotoCollectionViewCell.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPhotoModel;
@interface MPhotoCollectionViewCell : UICollectionViewCell

- (void)updateWithPhotoModel:(MPhotoModel *)photoModel;

@end
