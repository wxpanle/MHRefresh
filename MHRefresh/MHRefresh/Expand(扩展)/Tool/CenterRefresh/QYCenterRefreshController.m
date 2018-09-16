//
//  QYCenterRefreshController.m
//  MHRefresh
//
//  Created by panle on 2018/9/16.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYCenterRefreshController.h"
#import <MJRefresh/MJRefresh.h>

@interface QYCenterRefreshController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, strong) UIScrollView *bottomView;

@property (nonatomic, strong) UITableView *tableView1;

@property (nonatomic, strong) UITableView *tableView2;

@end

@implementation QYCenterRefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.bgScrollView class];
    [self.topView class];
    [self.menuView class];
    [self.bottomView class];
    [self.tableView1 class];
    [self.tableView2 class];
    
    
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
    
    self.tableView1.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView1.mj_header endRefreshing];
        });
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.title = @"test";
}

- (UIScrollView *)bgScrollView {
    
    if (nil == _bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _bgScrollView.delegate = self;
        _bgScrollView.contentSize = CGSizeMake(SCREEN_W, 150.0 + SCREEN_H - kTopHeight);
        K_IOS11_SET_INSET_NEVER_OC(_bgScrollView)
        [self.view addSubview:_bgScrollView];
    }
    return _bgScrollView;
}

- (UIView *)topView {
    
    if (nil == _topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 150)];
        _topView.backgroundColor = [UIColor redColor];
        [self.bgScrollView addSubview:_topView];
    }
    return _topView;
}

- (UIView *)menuView {
    if (nil == _menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_W, 40)];
        _menuView.backgroundColor = [UIColor greenColor];
        [self.bgScrollView addSubview:_menuView];
    }
    return _menuView;
}

- (UIScrollView *)bottomView {
    if (nil == _bottomView) {
        _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 150 + 40, SCREEN_W, SCREEN_H - kTopHeight)];
        _bottomView.delegate = self;
        _bottomView.contentSize = CGSizeMake(SCREEN_W, SCREEN_H - kTopHeight);
        K_IOS11_SET_INSET_NEVER_OC(_bottomView)
        [self.bgScrollView addSubview:_bottomView];
    }
    return _bottomView;
}

- (UITableView *)tableView1 {
    
    if (nil == _tableView1) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - kTopHeight)];
        _tableView1.delegate = self;
        _tableView1.dataSource = self;
        _tableView2.rowHeight = 44.0;
        K_IOS11_SET_INSET_NEVER_OC(_tableView1);
        [_tableView1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.bottomView addSubview:_tableView1];
    }
    return _tableView1;
}

- (UITableView *)tableView2 {
    if (nil == _tableView2) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H - kTopHeight)];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.rowHeight = 44.0;
        K_IOS11_SET_INSET_NEVER_OC(_tableView2);
        [_tableView2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.bottomView addSubview:_tableView2];
    }
    return _tableView2;
}


#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [@(indexPath.row).stringValue stringByAppendingString:@"test"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20.0;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"%@ %@ %@", NSStringFromCGPoint(scrollView.contentOffset), NSStringFromCGPoint(_bgScrollView.contentOffset), NSStringFromCGPoint(_bottomView.contentOffset));
    
    if (scrollView == _bgScrollView) {
        
        if (scrollView.contentOffset.y ) {
            
        }
        
    } else {
        
        if (scrollView.contentOffset.y < 0.0) { //向上滑动
            
            if (_bgScrollView.contentOffset.y > 0.0) {
                //手动调整
                _bgScrollView.contentOffset = CGPointMake(0, _bgScrollView.contentOffset.y + scrollView.contentOffset.y);
                scrollView.contentOffset = CGPointZero;
            } else {
                DLog(@"向上 不变");
            }
            
        } else {
            
            if (_bgScrollView.contentOffset.y < (150.0 - kTopHeight)) { //向下
                //手动调整
                _bgScrollView.contentOffset = CGPointMake(0, _bgScrollView.contentOffset.y + scrollView.contentOffset.y);
                scrollView.contentOffset = CGPointZero;
            } else {
                DLog(@"向下 不变");
            }
            
        }
        
//        if (_bgScrollView.contentOffset.y < (150.0 - kTopHeight) ) {
//            _bgScrollView.contentOffset = CGPointMake(0, _bgScrollView.contentOffset.y + CGFloat_fab(scrollView.contentOffset.y));
//            [scrollView setContentOffset:CGPointZero]; //滚动回去
//        } else {
//
//        }
        
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    if (scrollView == _bgScrollView) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
