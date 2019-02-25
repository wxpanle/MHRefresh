//
//  UPReportEntryCell.h
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPBaseTableViewCell.h"

@class UPReportEntryModel;

@interface UPReportEntryCell : UPBaseTableViewCell

- (void)up_updateDataWithReportEntryModel:(UPReportEntryModel *)model;

@end
