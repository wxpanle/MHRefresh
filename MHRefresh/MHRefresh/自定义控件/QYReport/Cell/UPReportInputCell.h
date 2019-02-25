//
//  UPReportInputCell.h
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPBaseTableViewCell.h"

@class UPReportInputCell, UPReportEntryModel;

@protocol UPReportInputCellDelegate <NSObject>

- (void)up_reportInputCellTextChangeEvent:(UPReportInputCell *)cell text:(NSString *)text;

@end

@interface UPReportInputCell : UPBaseTableViewCell

@property (nonatomic, weak) id <UPReportInputCellDelegate> delegate;

- (void)up_updateDataWithReportEntryModel:(UPReportEntryModel *)model;

- (void)up_becomeFirstResponder;
- (void)up_resignFirstResponder; 

@end
