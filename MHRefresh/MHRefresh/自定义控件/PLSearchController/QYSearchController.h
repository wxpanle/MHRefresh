//
//  QYSearchController.h
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QYSearchBar, QYSearchController;

@protocol QYSearchControllerDelegate <NSObject>

- (void)qy_searchControllerDelegateUpdate:(QYSearchBar *)searchBar title:(nullable NSString *)text;

@end

@interface QYSearchController : UIViewController

@property (nonatomic, weak) id <QYSearchControllerDelegate> updateDelegate;

@property (nonatomic, readonly) QYSearchBar *qy_searchBar;

@property (nonatomic, readonly, nullable) UIViewController *qy_resultViewController;

- (instancetype)initWithResultViewController:(nullable UIViewController *)resultViewController;

@end

NS_ASSUME_NONNULL_END
