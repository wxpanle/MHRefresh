//
//  QYTestTouchViewController.m
//  MHRefresh
//
//  Created by panle on 2019/3/15.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYTestTouchViewController.h"
#import "QYTestTouchTableViewCell.h"

@interface QYTestTouchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QYTestTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    
    _tableView.rowHeight = 60.0;
    
    [_tableView registerClass:[QYTestTouchTableViewCell class] forCellReuseIdentifier:[QYTestTouchTableViewCell reuseIdentifier]];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYTestTouchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QYTestTouchTableViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.up_indexPath = indexPath;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
