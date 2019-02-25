//
//  UPMessageReportView.h
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPMessageReportView, UPReportEntryModel;

/*
 共有4组
 第一组头(0)  返回1
 第二组举报的条目(1)  返回实际的条目个数
 第三组输入文本框(2)  返回1 或者0
 第四组发送按钮(3)    返回1
 */
@protocol UPMessageReportViewDataSource <NSObject>

@required 
- (NSInteger)up_messageReportView:(UPMessageReportView *)view numberOfRowsInSection:(NSInteger)section;
- (UPReportEntryModel *)up_messageReportViewEntryModelWithIndex:(NSInteger)index section:(NSInteger)section;
- (BOOL)up_messageReportViewIsAllowDoneEvent;

@end

@protocol UPMessageReportViewDelegate <NSObject>

- (void)up_messageReportViewTextChangeEvent:(UPMessageReportView *)reportView text:(NSString *)text;
- (void)up_messageReportViewSelectedEntryEvent:(UPMessageReportView *)reportView index:(NSInteger)index;
- (void)up_messageReportViewDoneEvent:(UPMessageReportView *)reportView;
- (void)up_messageReportViewCancelEvent:(UPMessageReportView *)reportView;

@end

@interface UPMessageReportView : UIView

@property (nonatomic, weak) id <UPMessageReportViewDelegate> delegate;
@property (nonatomic, weak) id <UPMessageReportViewDataSource> dataSource;

+ (instancetype)up_messageReportView;
- (void)up_showView;
- (void)up_cancel;

@end
