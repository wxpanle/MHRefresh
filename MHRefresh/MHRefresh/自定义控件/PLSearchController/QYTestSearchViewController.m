//
//  QYTestSearchViewController.m
//  MHRefresh
//
//  Created by panle on 2018/7/19.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYTestSearchViewController.h"
#import "QYSearchController.h"
#import "QYSearchBar.h"

static NSString *const kCellIdentifier = @"cell";

@interface QYTestSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSNumber *number;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QYSearchController *searchVc;

@end

@implementation QYTestSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.searchVc.qy_searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[@(indexPath.section).stringValue stringByAppendingString:@"+"] stringByAppendingString:@(indexPath.row).stringValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Home click index: %zd", indexPath.row);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44.0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.frame = CGRectMake(0, kTopHeight, SCREEN_W, SCREEN_H - kTopHeight);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (QYSearchController *)searchVc {
    
    if (nil == _searchVc) {
        _searchVc = [[QYSearchController alloc] initWithResultViewController:[[UIViewController alloc] init]];
    }
    return _searchVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
