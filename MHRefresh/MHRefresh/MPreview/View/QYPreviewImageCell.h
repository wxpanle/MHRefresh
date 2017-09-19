//
//  QYPreviewImageCell.h
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYPreviewDragImageState) {
    
    QYPreviewDragImageStateBegin,
    QYPreviewDragImageStateChange,
    QYPreviewDragImageStateRecover,
    QYPreviewDragImageStateRemove
};

@class QYPreviewImageModel, QYPreviewImageView;

@protocol QYPreviewImageCellDelegate <NSObject>

- (void)previewClickImage:(QYPreviewImageView *)imageView;

- (void)previewDragImage:(QYPreviewDragImageState)state offentYRatio:(CGFloat)offentYRatio;

@end


@interface QYPreviewImageCell : UICollectionViewCell

@property (nonatomic, weak) id <QYPreviewImageCellDelegate> delegate;

@property (nonatomic, strong, readonly) QYPreviewImageView *imageView;

- (CGFloat)getCurrentScale;

- (void)updateDataWithPreviewImageModel:(QYPreviewImageModel *)model;

- (void)endShow;

@end
