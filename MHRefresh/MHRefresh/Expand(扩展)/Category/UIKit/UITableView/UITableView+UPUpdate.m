//
//  UITableView+UPUpdate.m
//  Up
//
//  Created by panle on 2018/4/20.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UITableView+UPUpdate.h"

@implementation UITableView (UPUpdate)

- (void)up_insertSections:(NSIndexSet *)sections {
    [self beginUpdates];
    [self insertSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}
- (void)up_deleteSections:(NSIndexSet *)sections {
    [self beginUpdates];
    [self deleteSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}
- (void)up_reloadSections:(NSIndexSet *)sections {
    [self beginUpdates];
    [self reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (void)up_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}
- (void)up_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}
- (void)up_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

@end
