//
//  QYSearchController.m
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYSearchController.h"
#import "QYSearchBar.h"
#import "UIView+QYSearchExtension.h"

typedef NS_ENUM(NSInteger, UPSearchState) {
    UPSearchStateDefault,
    UPSearchStateNavigateBar
};

@interface QYSearchController () <QYSearchBarDelegate, QYSearchBarUpdateDelegate> {
    BOOL _isAddResultView;
}

@property (nonatomic, readwrite, strong) QYSearchBar *qy_searchBar;

@property (nonatomic, readwrite, strong) UIViewController *qy_resultViewController;

@property (nonatomic, assign) UPSearchState barState;

@end

@implementation QYSearchController

#pragma mark - init

- (instancetype)initWithResultViewController:(UIViewController *)resultViewController {
    
    if (self = [super init]) {
        _qy_resultViewController = resultViewController;
        _barState = UPSearchStateDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - QYSearchBarDelegate

- (void)qy_searchBarDidBeginEditing:(QYSearchBar *)searchBar {
    
}

- (void)qy_searchBarDidEndEditing:(QYSearchBar *)searchBar {
    
}


#pragma mark - QYSearchBarUpdateDelegate

- (BOOL)qy_searchBarShouldBeginEditing:(QYSearchBar *)searchBar {
    switch (_barState) {
        case UPSearchStateDefault:
            _barState = UPSearchStateNavigateBar;
            [self p_searchBarStartActionAnimation];
            [self.qy_searchBar qy_startAnimation];
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)qy_searchBarShouldEndEditing:(QYSearchBar *)searchBar {
    return YES;
}

- (void)qy_searchBarCancel:(QYSearchBar *)searchBar {
    switch (_barState) {
            
        case UPSearchStateNavigateBar:
            _barState = UPSearchStateDefault;
            [self p_searchBarEndActionAnimation];
            [self.qy_searchBar qy_endAnimation];
            break;
            
        default:
            break;
    }
}

- (void)qy_searchBar:(QYSearchBar *)searchBar textDidChange:(nullable NSString *)searchText {
    
    if (_updateDelegate && [_updateDelegate respondsToSelector:@selector(qy_searchControllerDelegateUpdate:title:)]) {
        [_updateDelegate qy_searchControllerDelegateUpdate:searchBar title:searchText];
    }
    
    if (!_qy_resultViewController) {
        return;
    }
    
    if (_qy_resultViewController.view.sm_y != self.view.sm_y) {
        _qy_resultViewController.view.sm_y = self.view.sm_y;
    }
    
    if (_isAddResultView) {
        return;
    }
    
    [self.view addSubview:_qy_resultViewController.view];
    _isAddResultView = YES;
}


#pragma mark - getter

- (void)p_searchBarStartActionAnimation {
    UIView *superView = self.qy_searchBar.qy_searchVc.view;
    if (self.qy_searchBar.qy_searchNavigationVc) {
        [self.qy_searchBar.qy_searchNavigationVc setNavigationBarHidden:YES animated:YES];
        [superView addSubview:self.view];
        [UIView animateWithDuration:0.25 animations:^{
            self.view.sm_y = kStatusBarHeight + CGRectGetHeight(self.qy_searchBar.frame);
            self.view.sm_height = SCREEN_H - CGRectGetHeight(self.qy_searchBar.frame);
            for (UIView *view in superView.subviews) {
                if (view != self.view) {
                    view.sm_y -= CGRectGetHeight(self.qy_searchBar.frame);
                    view.sm_height += CGRectGetHeight(self.qy_searchBar.frame);
                }
            }
        }];
    }
}

- (void)p_searchBarEndActionAnimation {
    UIView *superView = self.qy_searchBar.qy_searchVc.view;
    if (self.qy_searchBar.qy_searchNavigationVc) {
        [self.qy_searchBar.qy_searchNavigationVc setNavigationBarHidden:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.view.sm_y = kTopHeight + CGRectGetMaxY(self.qy_searchBar.frame);
            self.view.sm_height = kTopHeight - self.view.sm_y;
            for (UIView *view in superView.subviews) {
                view.sm_y += CGRectGetHeight(self.qy_searchBar.frame);
                view.sm_height -= CGRectGetHeight(self.qy_searchBar.frame);
            }
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            
            if (_isAddResultView) {
                [_qy_resultViewController.view removeFromSuperview];
                _isAddResultView = NO;
            }
        }];
    }
}

#pragma mark - getter

- (QYSearchBar *)qy_searchBar {
    
    if (nil == _qy_searchBar) {
        WeakSelf
        _qy_searchBar = [QYSearchBar qy_searchBarWithUpdateDelegate:weakSelf];
        _qy_searchBar.delegate = self;
        [_qy_searchBar qy_setPlaceholderString:@"搜索" state:UPSearchBarStateDefault];
        [_qy_searchBar qy_setPlaceholderString:@"搜索卡片" state:UPSearchBarStateEditing];
    }
    return _qy_searchBar;
}


#pragma mark - dealloc

- (void)dealloc {
    DLOG_DEALLOC
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
