//
//  UPMessageReportView.m
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPMessageReportView.h"
//#import "UPReportEntryModel.h"

#import "UPDReportHeaderCell.h"
#import "UPReportEntryCell.h"
#import "UPReportInputCell.h"
#import "UPReportDoneCell.h"

static const CGFloat kContainerViewEdge = 32.0;

@interface UPMessageReportView () <UITableViewDelegate, UITableViewDataSource, /*UPKeyboardDelegate,*/ UPReportDoneCellDelegate, UIGestureRecognizerDelegate, UPReportInputCellDelegate> {
    BOOL _editing;
}

@property (nonatomic, weak) UPReportInputCell *inputCell;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UPBaseTableView *tableView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation UPMessageReportView

+ (instancetype)up_messageReportView {
    return [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}
            
- (void)up_showView {
    
//    WeakSelf
//    [[UPKeyboardManager defaultManager] up_appendKeyboardDelegate:weakSelf];
//
//    _containerView.frame = [self p_containerViewFrame];
//    _tableView.frame = _containerView.bounds;
//    [_tableView reloadData];
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
//    self.alpha = 0.0;
//    [UIView animateWithDuration:UPDefaultAnimationDuration animations:^{
//        self.alpha = 1.0;
//    }];
}

- (void)up_cancel {
    [UIView animateWithDuration:UPDefaultAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self layoutOfUI];
    }
    return self;
}

#pragma mark - layoutUI

- (void)layoutOfUI {
    [self layoutUIOfSelf];
    [self layoutUIOfContainerView];
    [self layoutUIOfTableView];
    [self layoutUIOfTapGesture];
}

- (void)layoutUIOfSelf {
    self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
}

- (void)layoutUIOfContainerView {
    
//    _containerView = [UPFactory up_viewWithFrame:[self p_containerViewFrame] bgColor:[UIColor whiteColor] cornerRadius:4.0];
//    [self addSubview:_containerView];
}

- (void)layoutUIOfTableView {
    
//    _tableView = [[UPBaseTableView alloc] initWithFrame:_containerView.bounds style:UITableViewStylePlain];
//
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//
//    [_tableView registerClass:[UPDReportHeaderCell class] forCellReuseIdentifier:[UPDReportHeaderCell reuseIdentifier]];
//    [_tableView registerClass:[UPReportEntryCell class] forCellReuseIdentifier:[UPReportEntryCell reuseIdentifier]];
//    [_tableView registerClass:[UPReportInputCell class] forCellReuseIdentifier:[UPReportInputCell reuseIdentifier]];
//    [_tableView registerClass:[UPReportDoneCell class] forCellReuseIdentifier:[UPReportDoneCell reuseIdentifier]];
//
//    [_containerView addSubview:_tableView];
}

- (void)layoutUIOfTapGesture {
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_cancelCallBack)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource != nil ? [_dataSource up_messageReportView:self numberOfRowsInSection:section] : 0;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section != 1) {
//        return;
//    }
//    
//    [self p_callBackSelectedEntryInde:indexPath.row];
//    _containerView.frame = [self p_containerViewFrame];
//    _tableView.frame = _containerView.bounds;
//    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [UPDReportHeaderCell up_cellHeight];
    } else if (indexPath.section == 1) {
        return [UPReportEntryCell up_cellHeight];
    } else if (indexPath.section == 2) {
        return [UPReportInputCell up_cellHeight];
    } else {
        return [UPReportDoneCell up_cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UPDReportHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[UPDReportHeaderCell reuseIdentifier] forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        UPReportEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:[UPReportEntryCell reuseIdentifier] forIndexPath:indexPath];
        [cell up_updateDataWithReportEntryModel:[_dataSource up_messageReportViewEntryModelWithIndex:indexPath.row section:indexPath.section]];
        return cell;
    } else if (indexPath.section == 2) {
        UPReportInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[UPReportInputCell reuseIdentifier] forIndexPath:indexPath];
        [cell up_updateDataWithReportEntryModel:[_dataSource up_messageReportViewEntryModelWithIndex:indexPath.row section:indexPath.section]];
        _inputCell = cell;
        cell.delegate = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.inputCell up_becomeFirstResponder];
        });
        return cell;
    } else {
        UPReportDoneCell *cell = [tableView dequeueReusableCellWithIdentifier:[UPReportDoneCell reuseIdentifier] forIndexPath:indexPath];
        [cell up_updateDataWithIsAllowDoneEvent:[_dataSource up_messageReportViewIsAllowDoneEvent]];
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - UPKeyboardDelegate

- (void)up_keyBoardWillShowAnimationHeight:(CGFloat)height duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options {
//    CGFloat endY = 0;
//
//    if (SCREEN_H - MAX_Y(_containerView.frame) >= height) {
//        endY = _containerView.y;
//    } else {
//        endY = SCREEN_H - height - _containerView.height;
//    }
//
//    [UIView animateWithDuration:duration delay:0 options:options animations:^{
//        self.containerView.y = endY;
//    } completion:^(BOOL finished) {
//        self->_editing = YES;
//    }];
}

- (void)up_keyBoardWillHideHeight:(CGFloat)height duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options {
    
//    _containerView.frame = [self p_containerViewFrame];
//    _tableView.frame = _containerView.bounds;
//
//    [UIView animateWithDuration:duration delay:0 options:options animations:^{
//        self.containerView.y = (SCREEN_H - self.containerView.height) / 2.0;
//    } completion:^(BOOL finished) {
//        self->_editing = NO;
//    }];
}


#pragma mark - UPReportInputCellDelegate

- (void)up_reportInputCellTextChangeEvent:(UPReportInputCell *)cell text:(NSString *)text {
    [self p_inputChange:text];
}


#pragma mark - UPReportDoneCellDelegate

- (void)up_reportDoneCellDoneEvent:(UPReportDoneCell *)cell {
    [self p_doneCallBack];
    [_inputCell up_resignFirstResponder];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return !CGRectContainsPoint(_containerView.frame, [gestureRecognizer locationInView:self]);
}


#pragma mark - event

- (void)p_callBackSelectedEntryInde:(NSInteger)index {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(up_messageReportViewSelectedEntryEvent:index:)]) {
        [_delegate up_messageReportViewSelectedEntryEvent:self index:index];
    }
}

- (void)p_doneCallBack {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(up_messageReportViewDoneEvent:)]) {
        [_delegate up_messageReportViewDoneEvent:self];
    }
}

- (void)p_cancelCallBack {
    if (_editing) {
        //放弃编辑
        [_inputCell up_resignFirstResponder];
    } else {
        if (_delegate &&
            [_delegate respondsToSelector:@selector(up_messageReportViewCancelEvent:)]) {
            [_delegate up_messageReportViewCancelEvent:self];
        }
    }
}

- (void)p_inputChange:(NSString *)text {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(up_messageReportViewTextChangeEvent:text:)]) {
        [_delegate up_messageReportViewTextChangeEvent:self text:text];
    }
}

- (CGRect)p_containerViewFrame {
    
    if (!_dataSource) {
        return CGRectZero;
    }
    
    CGFloat height = 0;
    height += ([_dataSource up_messageReportView:self numberOfRowsInSection:0] * [UPDReportHeaderCell up_cellHeight]);
    height += ([_dataSource up_messageReportView:self numberOfRowsInSection:1] * [UPReportEntryCell up_cellHeight]);
    height += ([_dataSource up_messageReportView:self numberOfRowsInSection:2] * [UPReportInputCell up_cellHeight]);
    height += ([_dataSource up_messageReportView:self numberOfRowsInSection:3] * [UPReportDoneCell up_cellHeight]);
    return CGRectMake(kContainerViewEdge, (SCREEN_H - height) / 2.0, SCREEN_W - kContainerViewEdge * 2.0, height);
}

@end
