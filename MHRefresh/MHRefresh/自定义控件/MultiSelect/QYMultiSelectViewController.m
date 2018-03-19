//
//  QYMultiSelectViewController.m
//  MHRefresh
//
//  Created by panle on 2018/1/22.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYMultiSelectViewController.h"
#import "QYMultiSelectTableViewCell.h"

@interface QYMultiSelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL editing;

@end

@implementation QYMultiSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[QYMultiSelectTableViewCell class] forCellReuseIdentifier:[QYMultiSelectTableViewCell reuseIdentifier]];
    
    [self.view addSubview:self.tableView];
    

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(startEdit)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - ========  ========

- (void)startEdit {
    
    if (self.editing == NO) {
        
        NSArray *array = [self.tableView visibleCells];
        
        [UIView animateWithDuration:0.25 animations:^{
            for (QYMultiSelectTableViewCell *cell in array) {
                [cell startEditAnimation];
            }
        } completion:^(BOOL finished) {
            DLog(@"编辑准备结束");
        }];
        
        
        
    } else {
        
        NSArray *array = [self.tableView visibleCells];
        [UIView animateWithDuration:0.25 animations:^{
            for (QYMultiSelectTableViewCell *cell in array) {
                [cell endEditAnimation];
            }
        } completion:^(BOOL finished) {
            DLog(@"编辑准备结束");
        }];
    }
    
    self.editing = !self.editing;
}

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ======== UITableViewDelegate ========
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return 120;
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

#pragma mark - ======== UITableViewDataSource ========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYMultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QYMultiSelectTableViewCell reuseIdentifier] forIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%ld", section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
