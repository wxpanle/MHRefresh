//
//  UITableView+UPUpdate.h
//  Up
//
//  Created by panle on 2018/4/20.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (UPUpdate)

- (void)up_insertSections:(NSIndexSet *)sections;
- (void)up_deleteSections:(NSIndexSet *)sections;
- (void)up_reloadSections:(NSIndexSet *)sections;

- (void)up_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)up_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)up_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end
