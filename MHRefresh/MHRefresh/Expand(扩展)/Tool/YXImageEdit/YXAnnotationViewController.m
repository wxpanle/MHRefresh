//
//  YXAnnotationViewController.m
//  Annotation
//
//  Created by zyx on 2017/4/28.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXAnnotationViewController.h"
#import "YXAnnotationConfig.h"
#import "YXAnnotationTabbarView.h"
#import "YXAnnotationView.h"
#import "YXCollectionViewCell.h"
#import "YXAnnotationShapeViewAction.h"

static CGFloat kAnimationDuration = 0.5;

@interface YXAnnotationViewController () <YXAnnotationTabbarViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YXAnnotationViewDelegate>

@property (nonatomic, strong) UIView *setView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *undoButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) YXAnnotationTabbarView *tabbar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YXAnnotationView *annoView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL showEdit;

@property (nonatomic, strong) NSMutableArray *shapeViewActions;

@property (nonatomic, strong) UIView *rotateCoverView;

@property (nonatomic, strong) UIImage *image;

@end

@implementation YXAnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _shapeViewActions = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.annoView];
    self.scrollView.zoomScale = 1.25;
    
    [self.view addSubview:self.setView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (UIColor *)colorForItem:(NSInteger)item {
    return @[[UIColor blackColor], [UIColor whiteColor], [UIColor grayColor], [UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]][item];
}

- (UIImage *)imageForItem:(NSInteger)item {
    return @[[UIImage imageNamed:@"an_shape_square"], [UIImage imageNamed:@"an_shape_round"]][item];
}

- (void)setUndoButtonEnabled {
    self.undoButton.enabled = _shapeViewActions.count != 0;
}

- (void)removeCoverView {
    [_rotateCoverView removeFromSuperview];
    _rotateCoverView = nil;
}

- (void)startRotate {
    
    [_tabbar showRotate];
    
    if (self.collectionView.frame.origin.y != CGRectGetMinY(_tabbar.frame)) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.collectionView.frame = CGRectMake(0, CGRectGetMinY(_tabbar.frame), M_WIDGHT, 60);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    // 删除多余的
    [_annoView removeAllAnnotatedView];
    _scrollView.zoomScale = 1.25;
    
    [_shapeViewActions removeAllObjects];
    [self setUndoButtonEnabled];
    
    [self.view addSubview:self.rotateCoverView];
    
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 22, 22);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - event

- (void)beginEdit {

    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.undoButton];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tabbar];

    _annoView.type = AnnotationTypeRectangle;
    _annoView.color = [UIColor redColor];
    
    self.showEdit = YES;
}

- (void)undo {
    
    YXAnnotationShapeViewAction *curAction = [_shapeViewActions lastObject];
    
    switch (curAction.action) {
        case Create: {
            [curAction.shapeView removeFromSuperview];
            break;
        }
        case Change:{ // 遍历之前的属于这个 shapeView
            
            for (NSInteger i = _shapeViewActions.count - 2; i >=0; i --) {
                YXAnnotationShapeViewAction *action =_shapeViewActions[i];
                if (action.shapeView == curAction.shapeView) {
                    [curAction.shapeView setColor:action.color frame:action.rect annotationType:action.type];
                    break;
                }
            }
            
            break;
        }
        case Delete: {
            [self.annoView addSubview:curAction.shapeView];
            break;
        }
    }

    
    [_shapeViewActions removeLastObject];
    
    [self setUndoButtonEnabled];
}

- (void)back {
    if ([self.delegate respondsToSelector:@selector(yxAnnotationViewControllerCancelAnnotatedImage:)]) {
        [self.delegate yxAnnotationViewControllerCancelAnnotatedImage:self];
    }
}

- (void)cancelAnnotated {
    
    if ([_annoView containShapeView]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"当前图片已添加形状" message:@"确认取消？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault    handler:nil];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.showEdit = false;
        }];
        
        [alertVc addAction:cancelAction];
        [alertVc addAction:confirmAction];
        
        [self presentViewController:alertVc animated:YES completion:nil];
    } else {
        self.showEdit = false;
    }
}

- (void)finishAnnotated {
    
    UIImage *new = [_annoView getAnnotatedImage];
    
    if ([self.delegate respondsToSelector:@selector(yxAnnotationViewController:didAnnotatedWithNewImage:originImage:)]) {
        [self.delegate yxAnnotationViewController:self didAnnotatedWithNewImage:new originImage:_originImage];
    }
}


#pragma mark - delegate

#pragma mark - YXAnnotationViewDelegate

- (void)yxAnnotationView:(YXAnnotationView *)view didDeleteShapeView:(YXAnnotationShapeView *)shapeView {
    
    YXAnnotationShapeViewAction *action = [[YXAnnotationShapeViewAction alloc] initWithColor:shapeView.color   action:Delete rect:shapeView.frame type:shapeView.type shapeView:shapeView];
    
    [self.shapeViewActions addObject:action];
    
    [self setUndoButtonEnabled];
}

- (void)yxAnnotationView:(YXAnnotationView *)view didCreateShapeView:(YXAnnotationShapeView *)shapeView {

    YXAnnotationShapeViewAction *action = [[YXAnnotationShapeViewAction alloc] initWithColor:shapeView.color action:Create rect:shapeView.frame type:shapeView.type shapeView:shapeView];
    
    [self.shapeViewActions addObject:action];
    [self setUndoButtonEnabled];
}

- (void)yxAnnotationView:(YXAnnotationView *)view didSelectShapeView:(YXAnnotationShapeView *)shapeView {

}

- (void)yxAnnotationView:(YXAnnotationView *)view didChangeShapeView:(YXAnnotationShapeView *)shapeView {
    
    YXAnnotationShapeViewAction *action = [[YXAnnotationShapeViewAction alloc] initWithColor:shapeView.color  action:Change rect:shapeView.frame type:shapeView.type shapeView:shapeView];
    
    [self.shapeViewActions addObject:action];
    [self setUndoButtonEnabled];
}

- (void)yxAnnotationViewTapBlankArea:(YXAnnotationView *)view {

}

#pragma mark - YXAnnotationTabbarViewDelegate


- (void)yxAnnotationTabbarView:(YXAnnotationTabbarView *)view didSelectItem:(YXAnnotationTabbarItem)item originItem:(YXAnnotationTabbarItem)originItem {
   
    if (item == YXAnnotationTabbarItemRotate) {
        
        if ([_annoView containShapeView]) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"已添加的形状删除后才能旋转" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault    handler:nil];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self startRotate];
            }];
            
            [alertVc addAction:cancelAction];
            [alertVc addAction:confirmAction];
            
            [self presentViewController:alertVc animated:YES completion:nil];
        } else {
            
            [self startRotate];
        }
        

        return;
    }
    
    if (item == originItem && self.collectionView.frame.origin.y != CGRectGetMinY(_tabbar.frame)) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.collectionView.frame = CGRectMake(0, CGRectGetMinY(_tabbar.frame), M_WIDGHT, 60);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.collectionView.frame = CGRectMake(0, CGRectGetMinY(_tabbar.frame) - 60, M_WIDGHT, 60);
        } completion:^(BOOL finished) {
        }];
    }

}

- (void)yxAnnotationTabbarViewDidTapRotateButton:(YXAnnotationTabbarView *)view {
    
    [_annoView rotatedMPI2AdjustScreen];
    
}


- (void)yxAnnotationTabbarViewCancelRotate:(YXAnnotationTabbarView *)view {
    
    [self removeCoverView];
    
    [_annoView setImage:_image];
}

- (void)yxAnnotationTabbarViewConfirmRotate:(YXAnnotationTabbarView *)view {
    
    UIImage *image = [_annoView getRotateImage];
    _image = image;
    
    [self removeCoverView];
    [_annoView setImage:image];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _annoView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offSetX = MAX((scrollView.frame.size.width - scrollView.contentSize.width) / 2, 0);
    CGFloat offSetY = MAX((scrollView.frame.size.height - scrollView.contentSize.height) / 2, 0);
    scrollView.contentInset = UIEdgeInsetsMake(offSetY, offSetX, 0, 0);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _tabbar.selectedItem == YXAnnotationTabbarItemShape ? CGSizeMake(M_WIDGHT / 2, 60) : CGSizeMake(60, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_tabbar.selectedItem == YXAnnotationTabbarItemShape) {
        _annoView.type = indexPath.row;
        
        switch (_annoView.type) {
            case AnnotationTypeRectangle:{
                [_tabbar setImage:[UIImage imageNamed:@"an_shape_square"] atIndex:0];
                break;
            }
            case AnnotationTypeRound: {
                [_tabbar setImage:[UIImage imageNamed:@"an_shape_round"] atIndex:0];
                break;
            }
        }
        
    }
    
    if (_tabbar.selectedItem == YXAnnotationTabbarItemColor) {
        _annoView.color = [self colorForItem:indexPath.row];
        [_tabbar setImage:[self createImageWithColor:_annoView.color] atIndex:1];
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.collectionView.frame = CGRectMake(0, CGRectGetMinY(_tabbar.frame), M_WIDGHT, 60);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - dataSource

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YXCollectionViewCell class]) forIndexPath:indexPath];
    
    if (self.tabbar.selectedItem == YXAnnotationTabbarItemShape) {
        [cell setCellType:CellTypeOfShape style:[self imageForItem:indexPath.item]];
        if (indexPath.item == _annoView.type) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    if (self.tabbar.selectedItem == YXAnnotationTabbarItemColor) {
        UIColor *color = [self colorForItem:indexPath.item];
        [cell setCellType:CellTypeOfColor style:color];
        if (color == _annoView.color) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _tabbar.selectedItem == YXAnnotationTabbarItemShape ? 2 : 7;
}


#pragma mark - setting 

- (void)setShowEdit:(BOOL)showEdit {
    
    _showEdit = showEdit;

    self.cancelButton.hidden = !showEdit;
    self.confirmButton.hidden = !showEdit;
    self.undoButton.hidden = !showEdit;
    
    self.tabbar.hidden = !showEdit;
    self.collectionView.hidden = !showEdit;
    self.setView.hidden = showEdit;
    
    if (!_showEdit) {
        self.collectionView.frame = CGRectMake(0, M_HEIGHT - 49, M_WIDGHT, 60);
    }
    
}

- (void)setOriginImage:(UIImage *)originImage {
    
    _originImage = originImage;
    
    _image = _originImage;
}


#pragma mark - getting

- (UIView *)setView {
    
    if (!_setView) {
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M_WIDGHT, 64)];
        topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelBtn];
        
        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, M_HEIGHT - 49, M_WIDGHT, 49)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [confirmBtn addTarget:self action:@selector(finishAnnotated) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:confirmBtn];
        
        CGSize size = [cancelBtn sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        
        cancelBtn.frame = CGRectMake(20, 0, size.width, 64);
        confirmBtn.frame = CGRectMake(M_WIDGHT - 20 - size.width, 0, size.width, 64);
        
        
        [view addSubview:topView];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, M_HEIGHT - 49, M_WIDGHT, 49)];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        [btn addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        _setView = view;
        
    }
    return _setView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 35, 35)];
        [btn setImage:[UIImage imageNamed:@"an_cancel"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelAnnotated) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = btn;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    
    if (!_confirmButton) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(M_WIDGHT - 35 - 15, 20, 35, 35)];
        [btn setImage:[UIImage imageNamed:@"an_confirm"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finishAnnotated) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton = btn;
    }
    return _confirmButton;
}

- (UIButton *)undoButton {
    
    if (!_undoButton) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.confirmButton.frame) - 35 - 30, 20, 35, 35)];
        [btn setImage:[UIImage imageNamed:@"an_undo"] forState:UIControlStateNormal];
        [btn setImage:nil forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
        _undoButton = btn;
    }
    return _undoButton;
}

- (YXAnnotationTabbarView *)tabbar {
    if (!_tabbar) {
        YXAnnotationTabbarView *tabbar = [[YXAnnotationTabbarView alloc] initWithFrame:CGRectMake(0, M_HEIGHT - 49, M_WIDGHT, 49)];
    
        tabbar.backgroundColor = [UIColor whiteColor];
        tabbar.delegate = self;

        [tabbar setImage:[UIImage imageNamed:@"an_shape_square"] atIndex:0];
        [tabbar setImage:[self createImageWithColor:[UIColor redColor]] atIndex:1];
        _tabbar = tabbar;

    }
    return _tabbar;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 2.5;
        scrollView.scrollEnabled = false;
        
        scrollView.contentSize = self.view.frame.size;
        scrollView.bounces = true;
        
        scrollView.delegate = self;
        
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (YXAnnotationView *)annoView {
    if (!_annoView) {
        YXAnnotationView *annoView = [[YXAnnotationView alloc] initWithFrame:[UIScreen mainScreen].bounds image:_image zoom:0.8];
        annoView.delegate = self;
        _annoView = annoView;
    }
    return _annoView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, M_HEIGHT - 49, M_WIDGHT, 60) collectionViewLayout:layout];
        

        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[YXCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YXCollectionViewCell class])];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIView *)rotateCoverView {
    
    if (!_rotateCoverView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M_WIDGHT, CGRectGetMinY(_tabbar.frame))];
        view.backgroundColor = [UIColor clearColor];
        
        _rotateCoverView = view;
    }
    return _rotateCoverView;
}




@end
