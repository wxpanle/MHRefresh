//
//  QYSearchBar.h
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UPSearchBarState) {
    UPSearchBarStateDefault = 0,
    UPSearchBarStateEditing
};

@class QYSearchBar;

@protocol QYSearchBarDelegate <NSObject>

@optional

- (void)qy_searchBarDidBeginEditing:(QYSearchBar *)searchBar;
- (void)qy_searchBarDidEndEditing:(QYSearchBar *)searchBar;

@end

@protocol QYSearchBarUpdateDelegate <NSObject>

- (BOOL)qy_searchBarShouldBeginEditing:(QYSearchBar *)searchBar;
- (BOOL)qy_searchBarShouldEndEditing:(QYSearchBar *)searchBar;
- (void)qy_searchBarCancel:(QYSearchBar *)searchBar;
- (void)qy_searchBar:(QYSearchBar *)searchBar textDidChange:(nullable NSString *)searchText;

@end

@interface QYSearchBar : UIView

+ (instancetype)qy_searchBarWithUpdateDelegate:(__weak id <QYSearchBarUpdateDelegate>)delegate;

@property (nonatomic, strong, nullable) UIImage *searchBgImage;
@property (nonatomic, strong, nullable) UIColor *searchBgColor;
@property (nonatomic, strong, nullable) UIColor *searchTextFieldBgColor;

@property (nonatomic, weak) id <QYSearchBarDelegate> delegate;

- (void)qy_setPlaceholderString:(NSString *)placeholder state:(UPSearchBarState)state;

- (void)qy_becomeFirstResponder;
- (void)qy_resignFirstResponder;

- (void)qy_startAnimation;
- (void)qy_endAnimation;

@end

NS_ASSUME_NONNULL_END
