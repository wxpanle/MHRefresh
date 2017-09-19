//
//  QYPreviewImageCell.m
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "QYPreviewImageCell.h"
#import "QYPreviewImageView.h"
#import "QYPreviewImageModel.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "QYPreviewImageHeader.h"

#define QYPreviewMaxScale 2.0
#define QY_IS_LANDSCAPE self.frame.size.width > self.frame.size.height ? YES : NO
#define QY_Pan_Remove_Ratio 120.0

// 旋转角为PI的整数倍
#define QYHorizontal (ABS(_rotation) < 0.01 || ABS(_rotation - M_PI) < 0.01 || ABS(_rotation - M_PI * 2) < 0.01)

// 旋转角为90°或者270°
#define QYVertical (ABS(_rotation - M_PI_2) < 0.01 || ABS(_rotation - M_PI_2 * 3) < 0.01)

@interface QYPreviewImageCell() <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, weak) UITapGestureRecognizer *cellTapGesture;

@property (nonatomic, weak) UITapGestureRecognizer *imageViewTapGesture;

@property (nonatomic, strong, readwrite) QYPreviewImageView *imageView;

@property (nonatomic, strong) QYPreviewImageModel *imageModel;

@property (nonatomic, strong) UIImage *previewImage;

@property (nonatomic, assign) CGPoint scrollViewAnchorPoint;

@property (nonatomic, assign) CGPoint photoCellAnchorPoint;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGRect scrollOroginalFrame;

@property (nonatomic, assign) CGSize originalSize;

@property (nonatomic, assign) CGFloat rotation;

@end

@implementation QYPreviewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self layoutUIOfContentScrollView];
    [self layoutUIOfImageView];
    [self layoutUIOfGestureRecognizers];
}

- (void)layoutUIOfSelf {
    self.scale = 1.0;
    self.rotation = 0;
}

- (void)layoutUIOfContentScrollView {
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, QY_SCREEN_W, QY_SCREEN_H)];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [self.contentView addSubview:self.contentScrollView];
}

- (void)layoutUIOfImageView {

    self.imageView = [[QYPreviewImageView alloc] init];
    [self.contentScrollView addSubview:self.imageView];
    self.scrollViewAnchorPoint = self.imageView.layer.anchorPoint;
}

- (void)layoutUIOfGestureRecognizers {
    
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
    [self addGestureRecognizer:cellTap];
    self.cellTapGesture = cellTap;
    
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidClicked:)];
    [self.imageView addGestureRecognizer:imageViewTap];
    self.imageViewTapGesture = imageViewTap;
}

- (void)setscrollViewAnchorPoint:(CGPoint)scrollViewAnchorPoint {
    
    // 当锚点异常时不赋值
    if (scrollViewAnchorPoint.x < 0.01 || scrollViewAnchorPoint.y < 0.01) return;
    _scrollViewAnchorPoint = scrollViewAnchorPoint;
}

// 监听transform
- (void)updateScrollView {
    
    // 调整scrollView
    // 恢复photoView的x/y位置
    self.imageView.sm_origin = CGPointZero;

    self.contentScrollView.sm_height = self.imageView.sm_height < self.sm_height ? self.imageView.sm_height : self.sm_height;
    self.contentScrollView.sm_width = self.imageView.sm_width < self.sm_width ? self.imageView.sm_width : self.sm_width;
    self.contentScrollView.contentSize = self.imageView.sm_size;
    
    // 根据模拟锚点调整偏移量
    CGFloat offsetX = self.contentScrollView.contentSize.width * self.scrollViewAnchorPoint.x - self.contentScrollView.sm_width * self.photoCellAnchorPoint.x;
    CGFloat offsetY = self.contentScrollView.contentSize.height * self.scrollViewAnchorPoint.y - self.contentScrollView.sm_height * self.photoCellAnchorPoint.y;
    
    if (ABS(offsetX) + self.contentScrollView.sm_width > self.contentScrollView.contentSize.width) {
        offsetX = offsetX > 0 ? self.contentScrollView.contentSize.width - self.contentScrollView.sm_width : self.contentScrollView.sm_width - self.contentScrollView.contentSize.width;
    }
    
    if (ABS(offsetY) + self.contentScrollView.sm_height > self.contentScrollView.contentSize.height) {          offsetY = offsetY > 0 ? self.contentScrollView.contentSize.height - self.contentScrollView.sm_height :
            self.contentScrollView.sm_height - self.contentScrollView.contentSize.height;
    }
    
    offsetX = offsetX < 0 ? 0 : offsetX;
    offsetY = offsetY < 0 ? 0 : offsetY;
    self.contentScrollView.contentOffset = CGPointMake(offsetX, offsetY);
    self.contentScrollView.center = CGPointMake(self.sm_width * 0.5, self.sm_height * 0.5);
}

- (void)addGestureRecognizers {
    
    // photoCell添加双击手势
    UITapGestureRecognizer *doubleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidDoubleClicked:)];
    [doubleTap1 setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap1];
    
    // photoCell单击双击共存时，单击失效
    [self.cellTapGesture requireGestureRecognizerToFail:doubleTap1];
    
    // photoCell添加捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidPinch:)];
    [self addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidPan:)];
    pan.delegate = self;
    [self.contentScrollView addGestureRecognizer:pan];
    
    // 添加双击手势
    UITapGestureRecognizer *doubleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidDoubleClicked:)];
    [doubleTap2 setNumberOfTapsRequired:2];
    [self.imageView addGestureRecognizer:doubleTap2];
    // 单击双击共存时，避免双击失效
    [self.imageViewTapGesture requireGestureRecognizerToFail:doubleTap2];
}

- (void)removeGestureRecognizers {
    
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if (!([gesture isKindOfClass:[UITapGestureRecognizer class]] && ((UITapGestureRecognizer *)gesture).numberOfTapsRequired == 1)) {
            [self removeGestureRecognizer:gesture];
        }
    }
    
    for (UIGestureRecognizer *gesture in self.imageView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]] && ((UITapGestureRecognizer *)gesture).numberOfTapsRequired == 2) {
            [self.imageView removeGestureRecognizer:gesture];
        }
    }
}

- (void)imageDidPinch:(UIPinchGestureRecognizer *)pinch {
    
    if (pinch.numberOfTouches < 2) {
        [pinch setCancelsTouchesInView:YES];
        [pinch setValue:@(UIGestureRecognizerStateEnded) forKey:@"state"];
    }
    
    switch (pinch.state) {
        case UIGestureRecognizerStateChanged: {
            
            self.scrollViewAnchorPoint = [self setAnchorPointBaseOnGestureRecognizer:pinch];
            
            CGFloat scaleFactor = 1.0;
            if (self.imageView.sm_width > self.sm_width * QYPreviewMaxScale && pinch.scale > 1.0) {
                scaleFactor =  (1 + 0.01 * pinch.scale) /  pinch.scale;
            }
            
            self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale * scaleFactor, pinch.scale * scaleFactor);
            [self updateScrollView];

            pinch.scale = 1;
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            
            CGFloat scale = 1;
            
            if (QYHorizontal) {

                if (self.imageView.sm_width <= QY_SCREEN_W) {
                    scale = QY_SCREEN_W / self.imageView.sm_width >= 1.0 ? QY_SCREEN_W / self.imageView.sm_width : 1.0;
                } else if (self.imageView.sm_width > QY_SCREEN_W * QYPreviewMaxScale) {
                    scale = QY_SCREEN_W * QYPreviewMaxScale / self.imageView.sm_width;
                }
            } else if (QYVertical) {
                
                if (self.imageView.sm_height <= QY_SCREEN_W) {
                    scale = QY_SCREEN_W / self.imageView.sm_height;
                } else if (self.imageView.sm_height > self.sm_height * QYPreviewMaxScale) {
                    scale = QY_SCREEN_W * QYPreviewMaxScale / self.imageView.sm_height;
                }
            }

            [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
                [self updateScrollView];
            } completion:^(BOOL finished) {
                self.scale = self.imageView.sm_width / QY_SCREEN_W;
            }];
            
            break;
        }
            
        default:
            break;
    }

}

// 双击手势（只有图片在预览状态时才支持）
- (void)imageDidDoubleClicked:(UITapGestureRecognizer *)doubleTap {
    
    // 设置锚点
    self.scrollViewAnchorPoint = [self setAnchorPointBaseOnGestureRecognizer:doubleTap];
    
    // 放大倍数（默认为放大）
    CGFloat scale = QYPreviewMaxScale;
    if ((self.imageView.sm_width - QY_SCREEN_W) > 0.01) {
        scale = QY_SCREEN_W / self.imageView.sm_width;
    }
    
    [UIView animateWithDuration:0.25  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
        [self updateScrollView];
    } completion:^(BOOL finished) {
        // 记录放大倍数
        self.scale = self.imageView.sm_width / QY_SCREEN_W;
    }];
}

// 单击手势
- (void)imageDidClicked:(UITapGestureRecognizer *)tap {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewClickImage:)]) {
        [self.delegate previewClickImage:self.imageView];
    }
}

- (void)imageDidPan:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.scrollOroginalFrame = self.contentScrollView.frame;
            [self callBackImagePanWithState:QYPreviewDragImageStateBegin ratio:1.0];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint velocity = [pan translationInView:self.contentScrollView];
            self.contentScrollView.sm_y = self.contentScrollView.sm_y + velocity.y;
            self.contentScrollView.sm_x = self.contentScrollView.sm_x + velocity.x;
            [pan setTranslation:CGPointZero inView:self];
            
            CGFloat ratio = (self.contentScrollView.sm_y - self.scrollOroginalFrame.origin.y) / QY_Pan_Remove_Ratio;
            ratio = CGFloat_fabs(ratio) > 1.0 ? 0.8 : CGFloat_fabs(ratio);
            
            [self callBackImagePanWithState:QYPreviewDragImageStateChange ratio:ratio];
            
            break;
        }
            
        default: {
            
            CGFloat ratio = (self.contentScrollView.sm_y - self.scrollOroginalFrame.origin.y) / QY_Pan_Remove_Ratio;
            ratio = CGFloat_fabs(ratio);
            
            BOOL isNeedRecover = YES;
            
            if (ratio >= 1.0) {
                if ([self callBackImagePanWithState:QYPreviewDragImageStateRemove ratio:0.8]) {
                    isNeedRecover = NO;
                }
            } else {
                [self callBackImagePanWithState:QYPreviewDragImageStateRecover ratio:1.0];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.contentScrollView.frame = self.scrollOroginalFrame;
            }];
        }
            break;
    }
}

- (BOOL)callBackImagePanWithState:(QYPreviewDragImageState)state ratio:(CGFloat)ratio {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewDragImage:offentYRatio:)]) {
        [self.delegate previewDragImage:state offentYRatio:ratio];
        return YES;
    }
    return NO;
}

#pragma mark - update data
- (void)updateDataWithPreviewImageModel:(QYPreviewImageModel *)model {
    
    self.imageModel = model;
    
    [self removeGestureRecognizers];
    
    if (model.originImage) {
        [self setImage:model.originImage];
        [self addGestureRecognizers];
        return;
    }
    
    NSURL *url = nil;
    if (model.originUrl) {
        url = [NSURL URLWithString:model.originUrl];
    } else if (model.thumbnailUrl) {
        url = [NSURL URLWithString:model.thumbnailUrl];
    } else {
        return;
    }

    
    [self.imageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
        DLog(@"%ld %ld", (long)receivedSize, (long)expectedSize);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image && [[imageURL absoluteString] isEqualToString:self.imageModel.originUrl]) {
            [self addGestureRecognizers];
            [self setImage:image];
            self.imageModel.originImage = image;
            
        } else if (image && [[imageURL absoluteString] isEqualToString:self.imageModel.thumbnailUrl]) {
            [self addGestureRecognizers];
            [self setImage:image];
            self.imageModel.thumbnailImage = image;
        } else {
            
        }
    }];
}

- (void)endShow {
    
    if (self.scale != 1.0) {
        self.scale = 1.0;
        self.rotation = 0.0;
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.sm_height = QY_SCREEN_W * self.imageView.sm_height / self.imageView.sm_width;
        self.imageView.sm_width = QY_SCREEN_W;
        
        self.contentScrollView.contentSize = self.imageView.sm_size;
        self.contentScrollView.sm_size = self.imageView.sm_size;
        self.contentScrollView.contentOffset = CGPointZero;
        self.contentScrollView.contentInset = UIEdgeInsetsZero;
        self.contentScrollView.sm_x = 0;
        self.contentScrollView.sm_y = (QY_SCREEN_H - self.contentScrollView.sm_height) * 0.5;
        self.contentScrollView.transform = CGAffineTransformIdentity;
    }
}

- (CGFloat)getCurrentScale {
    return self.scale;
}

/** 根据手势触摸点修改相应的锚点，就是沿着触摸点做相应的手势操作 */
- (CGPoint)setAnchorPointBaseOnGestureRecognizer:(UIGestureRecognizer *)gesture {
    
    if (nil == gesture) {
        return CGPointMake(0.5, 0.5);
    }
    
    // 创建锚点
    CGPoint anchorPoint = CGPointMake(0.5, 0.5);
    
    CGPoint cellAnchorPoint = CGPointMake(0.5, 0.5);
    
    if ([gesture isKindOfClass:[UIPinchGestureRecognizer class]]) { // 捏合手势
        if (gesture.numberOfTouches == 2) {

            CGPoint point1 = [gesture locationOfTouch:0 inView:self.contentScrollView];
            CGPoint point2 = [gesture locationOfTouch:1 inView:self.contentScrollView];
            anchorPoint.x = (point1.x + point2.x) / 2.0 / self.contentScrollView.contentSize.width;
            anchorPoint.y = (point1.y + point2.y) / 2.0 / self.contentScrollView.contentSize.height;
            // 获取cell上的触摸点
            CGPoint screenPoint1 = [gesture locationOfTouch:0 inView:gesture.view];
            CGPoint screenPoint2 = [gesture locationOfTouch:1 inView:gesture.view];
            cellAnchorPoint.x = (screenPoint1.x + screenPoint2.x) / 2.0 / gesture.view.sm_width;
            cellAnchorPoint.y = (screenPoint1.y + screenPoint2.y) / 2.0 / gesture.view.sm_height;
        }
    } else if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) { // 点击手势
        // 获取scrollView触摸点
        CGPoint scrollViewPoint = [gesture locationOfTouch:0 inView:self.contentScrollView];
        anchorPoint.x = scrollViewPoint.x / self.contentScrollView.contentSize.width;
        anchorPoint.y = scrollViewPoint.y / self.contentScrollView.contentSize.height;
        // 获取cell上的触摸点
        CGPoint photoCellPoint = [gesture locationOfTouch:0 inView:gesture.view];
        cellAnchorPoint.x = photoCellPoint.x / gesture.view.sm_width;
        cellAnchorPoint.y = photoCellPoint.y / gesture.view.sm_height;
    }
    self.photoCellAnchorPoint = cellAnchorPoint;
    return anchorPoint;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint point = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.contentScrollView];
        
        if (point.x != 0) {
            
            if (point.y == 0.0) {
                return NO;
            } else if (fabs(point.x) / fabs(point.y) >= 1.0) {
                return NO;
            } else {
                return YES;
            }
            
        } else if (point.y != 0) {
            
            if (point.x == 0.0) {
                return YES;
            } else if (fabs(point.y) / fabs(point.x) > 1.0) {
                return YES;
            } else {
                return NO;
            }
            
        } else {
            NO;
        }
    }
    
    return YES;
}

#pragma mark - set
- (void)setImage:(UIImage *)image {
    
    if (nil == image) {
        return;
    }
    
    BOOL isLandscape = self.sm_width > self.sm_height ? YES : NO;
    
    [self.imageView updateImage:image isLandscape:isLandscape];
    
    self.contentScrollView.sm_height = self.imageView.sm_height < self.sm_height ? self.imageView.sm_height : self.sm_height;
    self.contentScrollView.sm_width = self.imageView.sm_width < self.sm_width ? self.imageView.sm_width : self.sm_width;
    self.contentScrollView.center = CGPointMake(self.sm_width * 0.5, self.sm_height * 0.5);
    self.contentScrollView.contentSize = self.imageView.sm_size;
    
    DLog(@"contentScrollView = %@", NSStringFromCGRect(self.contentScrollView.frame));
}

#pragma mark - dealloc
- (void)dealloc {
    DLog(@"%@ dealloc", self);
}

@end
