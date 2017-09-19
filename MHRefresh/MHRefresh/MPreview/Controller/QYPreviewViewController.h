//
//  QYPreviewViewController.h
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYPreviewImageView;

NS_ASSUME_NONNULL_BEGIN

@protocol QYPreviewViewControllerDelegate <NSObject>

@required
- (nullable UIImage *)previewStartImage:(NSInteger)index;

- (nullable UIView *)previewAnimationView:(NSInteger)index;

@optional
- (void)previewWillStart:(NSInteger)index;

- (void)previewWillEnd:(NSInteger)index;

@end

@protocol QYPreviewViewControllerDataSource <NSObject>

@optional

- (NSInteger)previewDataSourceNumber;

- (nullable UIImage *)previewImageWithIndex:(NSInteger)index;

- (NSString *)previewImageUrlStringWithIndex:(NSInteger)index;

- (NSInteger)currentIndex;

@end

@interface QYPreviewViewController : UIViewController

+ (void)previewWithDelegate:(id <QYPreviewViewControllerDelegate>)delegate
                 dataSource:(id <QYPreviewViewControllerDataSource>)dataSource;

@end

NS_ASSUME_NONNULL_END
