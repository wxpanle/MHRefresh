//
//  QYPreviewViewController.m
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "QYPreviewViewController.h"
#import "QYPreviewWindow.h"
#import "QYPreviewImageCell.h"
#import "QYPreviewImageModel.h"
#import "QYPreviewImageView.h"
#import "QYPreviewImageHeader.h"

// 旋转角为90°或者270°
#define QY_SCREEN_V (ABS(acosf(self.window.transform.a) - M_PI_2) < 0.01 || ABS(acosf(self.window.transform.a) - M_PI_2 * 3) < 0.01)

static const NSTimeInterval kPreviewAnimationDuration = 0.5;

@interface QYPreviewViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QYPreviewImageCellDelegate>

@property (nonatomic, weak) id <QYPreviewViewControllerDelegate> delegate;

@property (nonatomic, weak) id <QYPreviewViewControllerDataSource> dataSource;

@property (nonatomic, assign, getter=isStatusBarHidden) BOOL statusBarHidden;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) QYPreviewWindow *window;

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, QYPreviewImageModel *> *imageDictionary;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger totalNumber;

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, assign, getter=isAnimation) BOOL animation;

@property (nonatomic, assign, getter=isRotating) BOOL rotating;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, assign) UIDeviceOrientation orientation;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *previewPageLabel;

@end

@implementation QYPreviewViewController

static BOOL isShowing = NO;

+ (void)previewWithDelegate:(id <QYPreviewViewControllerDelegate>)delegate
                 dataSource:(id <QYPreviewViewControllerDataSource>)dataSource {
    
    if (isShowing) {
        return;
    }
    
    isShowing = YES;
    
    QYPreviewViewController *vc = [[QYPreviewViewController alloc] init];
    vc.delegate = delegate;
    vc.dataSource = dataSource;

    vc.window = [[QYPreviewWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    vc.window.hidden = NO;
    vc.window.rootViewController = vc;
    
    [vc previewStartAnimation];
}

#pragma mark - init
- (instancetype)init {
    
    if (self = [super init]) {
        self.statusBarHidden = NO;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - StatusBarHidden
- (void)refreshStatusBarStatus {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.isStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}

-(BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

/*
 This method is called when the view controller's view's size is changed by its parent (i.e. for the root view controller when its window rotates or is resized).
 
 If you override this method, you should either call super to propagate the change to children or manually forward the change to children.
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0) {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    DLog(@"viewWillTransitionToSize %@", NSStringFromCGSize(size));
    
    self.rotating = YES;
    
    self.collectionView.sm_size = CGSizeMake(size.width + 30.0, size.height);
    
    NSInteger photosCount = [self previewTotalNumber];
    self.collectionView.contentSize = CGSizeMake(self.collectionView.sm_width * photosCount, size.height);
    self.collectionView.contentOffset = CGPointMake(self.currentIndex * self.collectionView.sm_width, 0);
    [self.collectionView reloadData];
    
    [coordinator animateAlongsideTransitionInView:self.collectionView animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.rotating = NO;
    }];
    
    
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        
//        self.rotating = NO;
//    }];
    
}


/*
 This method is called when the view controller's trait collection is changed by its parent.
 
 If you override this method, you should either call super to propagate the change to children or manually forward the change to children.
 */
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator NS_AVAILABLE_IOS(8_0) {
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    DLog(@"willTransitionToTraitCollection %f", coordinator.transitionDuration);
}

#pragma mark - layout

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self layoutUIOfCollectionView];
    [self layoutUIOfBackButton];
    [self layoutUIOfPreviewPageLabel];
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)layoutUIOfCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 30.0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(self.view.sm_width, self.view.sm_height);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.sm_width + flowLayout.minimumLineSpacing, self.view.sm_height) collectionViewLayout:flowLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, flowLayout.minimumLineSpacing);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[QYPreviewImageCell class] forCellWithReuseIdentifier:@"QYPreviewImageCell"];
    [self.view addSubview:self.collectionView];
}

- (void)layoutUIOfBackButton {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(15, 30, 50, 20);
    [self.backButton addTarget:self action:@selector(previewEndAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

- (void)layoutUIOfPreviewPageLabel {
    self.previewPageLabel = [[UILabel alloc] initWithFrame:CGRectMake((QY_SCREEN_W - 100) / 2.0, 30, 100, 20)];
    self.previewPageLabel.numberOfLines = 1;
    self.previewPageLabel.font = [UIFont systemFontOfSize:17.0];
    self.previewPageLabel.textColor = [UIColor whiteColor];
    self.previewPageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.previewPageLabel];
}

#pragma mark - previewAnimation
- (void)previewStartAnimation {

    self.animation = YES;
    
    self.view.alpha = 0.0;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(currentIndex)]) {
        self.currentIndex = [self.dataSource currentIndex];
        self.collectionView.contentOffset = CGPointMake(self.currentIndex * self.collectionView.sm_width, 0);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewWillStart:)]) {
        [self.delegate previewWillStart:self.currentIndex];
    }
    
    QYPreviewImageView *copyView = [[QYPreviewImageView alloc] init];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewStartImage:)]) {
        copyView.image = [self.delegate previewStartImage:self.currentIndex];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewAnimationView:)]) {
        UIView *view = [self.delegate previewAnimationView:self.currentIndex];
        copyView.frame = [[view superview] convertRect:view.frame toView:self.view];
    }
    
    [self.view addSubview:copyView];
    
    self.animationView = copyView;
    
    // 变大
    // 获取选中的图片的大小
    CGSize imageSize = copyView.image.size;
    
    // 添加控制器View
    self.collectionView.alpha = 0.0;
    [UIView animateWithDuration:kPreviewAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        copyView.sm_width = self.collectionView.sm_width - ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumLineSpacing;
        copyView.sm_height = QY_SCREEN_W * imageSize.height / imageSize.width;
        copyView.center = CGPointMake(QY_SCREEN_W * 0.5, QY_SCREEN_H * 0.5);
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.animation = NO;
        copyView.hidden = YES;
        self.collectionView.alpha = 1.0;
        [self.animationView removeFromSuperview];
    }];
    
    //更新当前下标
    [self updatePageNumber];
}

- (void)previewEndAnimation {
    
    self.animation = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewWillStart:)]) {
        [self.delegate previewWillStart:self.currentIndex];
    }
    
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        }
    }
    
    //隐藏所有控件
    [self refreshStatusBarStatus];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //获取当前正在展示的View
    QYPreviewImageView *animationView = ((QYPreviewImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]]).imageView;
    animationView.frame = [animationView convertRect:animationView.bounds toView:self.view];
    self.animationView = animationView;
    
    [self.view addSubview:animationView];

    //结束frame
    CGRect endFrame = CGRectZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewAnimationView:)]) {
        UIView *view = [self.delegate previewAnimationView:self.currentIndex];
        endFrame = [[view superview] convertRect:view.frame toView:self.view];
    }
    
    [self.collectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.collectionView.hidden = YES;
    [UIView animateWithDuration:kPreviewAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0.0;
        self.animationView.transform = CGAffineTransformIdentity;
        self.animationView.frame = endFrame;
        //视图超出范围
        if (!CGRectIntersectsRect(endFrame, [UIScreen mainScreen].bounds)) {
            self.animationView.hidden = YES;
        }
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(previewWillEnd:)]) {
            [self.delegate previewWillEnd:self.currentIndex];
        }
        
        self.animation = NO;
        
        self.animationView.hidden = YES;
        self.collectionView.hidden = YES;
        [self.animationView removeFromSuperview];
        
        self.window.rootViewController = nil;
        self.window.hidden = YES;
        
        isShowing = NO;
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self previewTotalNumber];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QYPreviewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QYPreviewImageCell" forIndexPath:indexPath];
    
    QYPreviewImageModel *model = [self getModelWithIndex:indexPath.item];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(previewImageWithIndex:)]) {
        model.originImage = [self.dataSource previewImageWithIndex:indexPath.item];
    }
    
    if (!model.originImage && self.dataSource && [self.dataSource respondsToSelector:@selector(previewImageUrlStringWithIndex:)]) {
         model.originUrl = [self.dataSource previewImageUrlStringWithIndex:indexPath.item];
    }
    
    
    cell.delegate = self;
    
    [cell updateDataWithPreviewImageModel:model];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //恢复cell布局
    QYPreviewImageCell *imageCell = (QYPreviewImageCell *)cell;
    [imageCell endShow];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.sm_width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing, self.collectionView.sm_height);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x >= scrollView.contentSize.width || self.isRotating) {
        return;
    }
    
    //更新当前页数
    CGFloat orginContentOffset = self.currentIndex * self.collectionView.sm_width;
    CGFloat diff = scrollView.contentOffset.x - orginContentOffset;
    if (CGFloat_fabs(diff) >= self.collectionView.sm_width) {
        self.currentIndex = diff >= 0 ? self.currentIndex + 1 : self.currentIndex - 1;
        [self updatePageNumber];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self getCurrentShowingPreviewImageView];
}

#pragma mark - QYPreviewImageCellDelegate
- (void)previewClickImage:(QYPreviewImageView *)imageView {
    
    [self showFullScreen];
}

- (void)previewDragImage:(QYPreviewDragImageState)state offentYRatio:(CGFloat)offentYRatio {
    
    switch (state) {
        case QYPreviewDragImageStateBegin: {
            
            [self setHiddenButton:YES];
            break;
        }
            
        case QYPreviewDragImageStateChange: {
            
            self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0 - offentYRatio];
            break;
        }
            
        case QYPreviewDragImageStateRecover: {
            self.view.backgroundColor = [UIColor blackColor];
            [self setHiddenButton:NO];
            break;
        }
            
        case QYPreviewDragImageStateRemove: {
            
            [self previewEndAnimation];
            break;
        }
            
        default:break;
    }
}

#pragma mark - help
- (NSInteger)previewTotalNumber {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(previewDataSourceNumber)]) {
        NSInteger number = [self.dataSource previewDataSourceNumber];
        
        if (number != self.totalNumber) {
            self.totalNumber = number;
            [self updatePageNumber];
        }
        return [self.dataSource previewDataSourceNumber];
    }
    return 0;
}

- (void)updatePageNumber {
    self.previewPageLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)self.currentIndex + 1, (long)self.totalNumber];
}

- (void)setHiddenButton:(BOOL)isHidden {
    self.backButton.hidden = isHidden;
    self.previewPageLabel.hidden = isHidden;
}

- (void)showFullScreen {
    
    CGFloat offentY = _fullScreen == YES ? 30.0 : 0 - self.backButton.sm_height;
    self.statusBarHidden = !_fullScreen;
    
    _fullScreen = !_fullScreen;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backButton.sm_y = offentY;
        self.previewPageLabel.sm_y = offentY;
        [self refreshStatusBarStatus];
    } completion:nil];
}

- (QYPreviewImageCell *)getCurrentShowingPreviewImageCell {
    
    return (QYPreviewImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
}

- (QYPreviewImageView *)getCurrentShowingPreviewImageView {
    
    QYPreviewImageView *imageView = nil;
    
    @try {
        imageView = ((QYPreviewImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]]).imageView;
    } @catch (NSException *exception) {
        
    } @finally {
        return imageView;
    }
}


#pragma mark - cache index data
- (QYPreviewImageModel *)getModelWithIndex:(NSInteger)index {
    
    QYPreviewImageModel *model = [self.imageDictionary objectForKey:@(index)];
    
    if (!model) {
        model = [[QYPreviewImageModel alloc] init];
        [self addModel:model WithIndex:index];
    }
    
    return model;
}

- (void)addModel:(QYPreviewImageModel *)model WithIndex:(NSInteger)index {
    [self.imageDictionary setObject:model forKey:@(index)];
}

#pragma mark - getter
- (NSMutableDictionary <NSNumber *, QYPreviewImageModel *> *)imageDictionary {
    
    if (nil == _imageDictionary) {
        _imageDictionary = [NSMutableDictionary dictionary];
    }
    return _imageDictionary;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"%@ dealloc", self);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
