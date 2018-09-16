//
//  UITableView+UPMJRefresh.m
//  Up
//
//  Created by panle on 2018/4/23.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UITableView+UPMJRefresh.h"

#if __has_include(<MJRefresh.h>)
#import <MJRefresh.h>
#else
#import "MJRefresh.h"
#endif

@implementation UITableView (UPMJRefresh)

- (void)up_mjRefreshHeaderWithTarget:(id)target selcector:(SEL)selector {
    
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:selector];
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    gifHeader.stateLabel.hidden = YES;
    
    [gifHeader setImages:[self p_pullImageArrayWithState:MJRefreshStateIdle] forState:MJRefreshStateIdle];
    [gifHeader setImages:[self p_pullImageArrayWithState:MJRefreshStatePulling] forState:MJRefreshStatePulling];
    [gifHeader setImages:[self p_pullImageArrayWithState:MJRefreshStateRefreshing] forState:MJRefreshStateRefreshing];
    
    self.mj_header = gifHeader;
}

- (void)up_mjRefreshFooterWithTarget:(id)target selector:(SEL)seletor {
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:seletor];
}
- (void)up_startRefreshHeader {
    [self.mj_header beginRefreshing];
}

- (void)up_endRefreshHeader {
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
}

- (void)up_startRefreshFooter {
    [self.mj_footer beginRefreshing];
}

- (void)up_endRefreshFooter:(BOOL)hidden {
    
    if (hidden) {
        self.mj_footer.hidden = YES;
        [self.mj_footer endRefreshingWithNoMoreData];
    } else {
        self.mj_footer.hidden = NO;
        [self.mj_footer endRefreshing];
    }
}


#pragma mark - ===== help =====
- (NSArray *)p_pullImageArrayWithState:(MJRefreshState)state {

    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    
    switch (state) {
        case MJRefreshStateIdle: {
            [imageArray addObject:[UIImage imageNamed:@"up_refresh_idel"]];
        }
            break;
            
        case MJRefreshStatePulling: {
            [imageArray addObject:[UIImage imageNamed:@"up_refresh_pulling"]];
        }
            break;
            
        case MJRefreshStateRefreshing: {
            for (int i = 0; i < 20; i++) {
                [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"up_refreshing_000%02d", i]]];
            }
        }
            break;
            
        default:
            break;
    }
    
    return [NSArray arrayWithArray:imageArray];
}

@end
