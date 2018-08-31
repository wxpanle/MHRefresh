//
//  UPBaseTableViewCell.h
//  Up
//
//  Created by panle on 2018/3/22.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPBaseTableView;

@interface UPBaseTableViewCell : UITableViewCell

/** tabView default nil need set */
@property (nonatomic, weak, nullable) UPBaseTableView *up_tableView;
/** cell indexPath */
@property (nonatomic, nullable) NSIndexPath *up_indexPath;
/** must set up_indexPath */
@property (nonatomic, assign) NSInteger up_row;
/** must set up_indexPath */
@property (nonatomic, assign) NSInteger up_section;

/**
 get cell default height 44.0,  subClass overwrite

 @return default 44.0
 */
+ (CGFloat)up_cellHeight;

- (void)up_hideSeparatorLine;
- (void)up_showSeparatorLine;

@end
