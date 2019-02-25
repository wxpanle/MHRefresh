//
//  UPReportDoneCell.h
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPBaseTableViewCell.h"

@class UPReportDoneCell;

@protocol UPReportDoneCellDelegate <NSObject>

- (void)up_reportDoneCellDoneEvent:(UPReportDoneCell *)cell;

@end

@interface UPReportDoneCell : UPBaseTableViewCell

@property (nonatomic, weak) id <UPReportDoneCellDelegate> delegate;

- (void)up_updateDataWithIsAllowDoneEvent:(BOOL)isAllow;

@end
