//
//  UITableView+UPMJRefresh.h
//  Up
//
//  Created by panle on 2018/4/23.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (UPMJRefresh)

- (void)up_mjRefreshHeaderWithTarget:(id)target selcector:(SEL)selector;

- (void)up_mjRefreshFooterWithTarget:(id)target selector:(SEL)seletor;

- (void)up_startRefreshHeader;

- (void)up_endRefreshHeader;

- (void)up_startRefreshFooter;

- (void)up_endRefreshFooter:(BOOL)hidden;

@end
