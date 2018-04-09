//
//  MAnnotationImageView.m
//  Annotable
//
//  Created by zyx on 2017/4/18.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXAnnotationView.h"
#import "YXAnnotationConfig.h"


@interface YXAnnotationView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray <YXAnnotationShapeView *>*shapeViews;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) YXAnnotationShapeView *currentShapeView; // 当前操作的 layer

@property (nonatomic, strong) YXAnnotationShapeView *selectShapeView;

@property (nonatomic, assign) EditType editType;

@property (nonatomic, assign) CGFloat zoom;

@property (nonatomic, assign) NSInteger rotateTimes;

@end

@implementation YXAnnotationView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image zoom:(CGFloat)zoom {
    
    self = [super initWithFrame:frame];
    
    self.zoom = zoom;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    _imageView = imageView;
    
    [self setImage:image];
    
    _shapeViews = [NSMutableArray new];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longDetect:)];
    longGes.minimumPressDuration = 0.0;
    [self addGestureRecognizer:longGes];

    return self;
}

- (YXAnnotationShapeView *)selectedShapeView {
    if (self.selectShapeView && self.selectShapeView.superview) {
        return self.selectShapeView;
    }
    return nil;
}

- (UIImage *)getAnnotatedImage {
    
    CGFloat scale = self.imageView.frame.size.width / self.imageView.image.size.width;
    
    CGSize size = self.imageView.image.size;
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, size.height);
    transform = CGAffineTransformScale(transform, 1, -1);
    CGContextConcatCTM(ctx, transform);
    
    CGContextDrawImage(ctx, (CGRect){0, 0, size}, _imageView.image.CGImage);
//    
    transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -size.height);
    CGContextConcatCTM(ctx, transform);
    
    for (YXAnnotationShapeView *shapeView in _shapeViews) {
        
        if (!shapeView.superview) {
            continue;
        }
        
        CGRect rect = CGRectMake(shapeView.frame.origin.x - _imageView.frame.origin.x, shapeView.frame.origin.y - _imageView.frame.origin.y, shapeView.frame.size.width, shapeView.frame.size.height);
        rect = CGRectMake(rect.origin.x / scale, rect.origin.y / scale, rect.size.width / scale, rect.size.height / scale);
        
        UIBezierPath *path;
        
        switch (shapeView.type)  {
            case AnnotationTypeRound:
                path = [UIBezierPath bezierPathWithOvalInRect:rect];
                break;
            case AnnotationTypeRectangle:{
                path = [UIBezierPath bezierPathWithRect:rect];
                break;
            }
        }
        
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetLineWidth(ctx, shapeView.lineWidth);
        [[shapeView color] setFill];
        CGContextFillPath(ctx);
    }
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}


- (void)removeAllAnnotatedView {
    
    for (YXAnnotationShapeView *elements in _shapeViews) {
        [elements removeFromSuperview];
    }
    [_shapeViews removeAllObjects];
}

- (void)rotatedMPI2AdjustScreen {
    
    _rotateTimes += 1;
    
    CGSize size = _imageView.image.size;
    
    CGRect frame = self.bounds;
    
    CGRect imageRect ;
    
    if (_rotateTimes % 2 == 1) { // 奇数次旋转
        CGFloat sc = size.height / size.width;
        
        if (frame.size.width / frame.size.height >  size.height / size.width) { // 高
            
            
            CGFloat w = frame.size.height * _zoom;
            CGFloat h = w * sc;
            
            imageRect = CGRectMake((frame.size.width - w) / 2,
                                   (frame.size.height - h) / 2,
                                   w,
                                   h);
        } else { // 宽
            
            CGFloat h = frame.size.width * _zoom;
            CGFloat w = h / sc;
            
            imageRect = CGRectMake((frame.size.width - w) / 2,
                                   (frame.size.height - h) / 2,
                                   w,
                                   h);

        }
        
    } else {
        CGFloat sc = size.width / size.height;
        if (frame.size.width / frame.size.height >  size.width / size.height) { // 高
            CGFloat h = frame.size.height * _zoom;
            CGFloat w = h * sc;
            imageRect = CGRectMake((frame.size.width - w) / 2,
                                   (frame.size.height - h) / 2,
                                   w,
                                   h);
        } else { // 宽
            CGFloat w = frame.size.width * _zoom;
            CGFloat h = w / sc;
            imageRect = CGRectMake((frame.size.width - w) / 2,
                                   (frame.size.height - h) / 2,
                                   w,
                                   h);
        }
    }

    _imageView.transform = CGAffineTransformIdentity;
    _imageView.frame = imageRect;
    _imageView.transform = CGAffineTransformMakeRotation((_rotateTimes % 4) * M_PI_2);
}

- (void)setImage:(UIImage *)image {
    _imageView.transform = CGAffineTransformIdentity;
    _rotateTimes = 0;
    
    CGRect frame = self.bounds;
    CGSize size = image.size;
    CGRect imageRect;
    
    if (frame.size.width / frame.size.height >  size.width / size.height) { // 高
        
        CGFloat sc = size.width / size.height;
        CGFloat h = frame.size.height * _zoom;
        CGFloat w = h * sc;
        
        imageRect = CGRectMake((frame.size.width - w) / 2,
                               (frame.size.height - h) / 2,
                               w,
                               h);
    } else { // 宽
        
        CGFloat sc = size.width / size.height;
        
        CGFloat w = frame.size.width * _zoom;
        CGFloat h = w / sc;
        
        imageRect = CGRectMake((frame.size.width - w) / 2,
                               (frame.size.height - h) / 2,
                               w,
                               h);
    }
    
    _imageView.image = image;
    _imageView.frame = imageRect;
    
}

- (UIImage *)getRotateImage {
    
    CGSize size = _imageView.image.size;
    CGContextRef ctx = NULL;
    if (_rotateTimes % 4 == 0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        ctx = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(ctx, 0, size.height);
        CGContextScaleCTM(ctx, 1, -1);

    } else if (_rotateTimes % 4 == 1) {
        size = CGSizeMake(size.height, size.width);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        ctx = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(ctx, 0, size.height);
        CGContextRotateCTM(ctx, -M_PI_2);
        CGContextTranslateCTM(ctx, size.height, 0);
        CGContextScaleCTM(ctx, -1, 1);
        

    } else if (_rotateTimes % 4 == 2) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        ctx = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(ctx, size.width, 0);
        CGContextScaleCTM(ctx, -1, 1);
        
    } else if (_rotateTimes % 4 == 3) {
        size = CGSizeMake(size.height, size.width);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        ctx = UIGraphicsGetCurrentContext();
        
        
        CGContextTranslateCTM(ctx, size.width, 0);
        CGContextRotateCTM(ctx, M_PI_2);
        
        CGContextTranslateCTM(ctx, size.height, 0);
        CGContextScaleCTM(ctx, -1, 1);
    }
	
    
    CGContextDrawImage(ctx, (CGRect){0, 0, _imageView.image.size}, _imageView.image.CGImage);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

- (BOOL)containShapeView {
    
    for (YXAnnotationShapeView *shapeView in _shapeViews) {
        if (shapeView.superview) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - gesture

static CGPoint prePoint;
static CGPoint sPoint;


- (void)longDetect:(UILongPressGestureRecognizer *)gesture {
    [self gestureDetect:gesture];
}

/*
 
 记录这九个点， 由这九个点拼接成 

*/
- (void)gestureDetect:(UIGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
           
            NSLog(@"begin");
            
            sPoint = [gesture locationInView:self];
            prePoint = sPoint;
            
            
            if (self.selectShapeView == [self getShapeViewWithPoint:sPoint] && [_selectShapeView editTypeAtPoint:[self convertPoint:sPoint toView:_selectShapeView]] == EditTypeOfDelete) { // 再次点击选中的 shapeview 删除操作
                
                [_selectShapeView removeFromSuperview];
                
                if ([self.delegate respondsToSelector:@selector(yxAnnotationView:didDeleteShapeView:)]) {
                    [self.delegate yxAnnotationView:self didDeleteShapeView:_selectShapeView];
                }
                
                _selectShapeView = nil;
                return;
            }
            
            self.selectShapeView = [self getShapeViewWithPoint:sPoint];
            
            if (_selectShapeView) {
                
                _editType = [_selectShapeView editTypeAtPoint:[self convertPoint:sPoint toView:_selectShapeView]];
                
                [_selectShapeView resetPoint];

            } else {
                // 不在 layer 里
                _currentShapeView = [self addShapeView];
            }

            break;
        }
        case UIGestureRecognizerStateChanged:{
            
            if (!_selectShapeView && !_currentShapeView) {
                return;
            }
            
            CGPoint point = [self pointWithOriginPoint:[gesture locationInView:self]];
            
            if (_selectShapeView) {
                [self setShapeViewFrame:_selectShapeView offSet:CGPointGetOffset(prePoint, point)];
                prePoint = point;
            }
            
            if (_currentShapeView) {
                CGRect rect = CGRectMake(MIN(point.x, sPoint.x), MIN(point.y, sPoint.y), fabs(point.x - sPoint.x), fabs(point.y - sPoint.y));
                _currentShapeView.frame = rect;
            }

            break;
        }
        case UIGestureRecognizerStateEnded:{

            if (!_selectShapeView && !_currentShapeView) {
                return;
            }
            
            if (CGPointEqualToPoint(sPoint, [gesture locationInView:self])) {
                
                if (_currentShapeView) {
                    [_currentShapeView removeFromSuperview];
                    _currentShapeView = nil;
                }
                return;
            }

            if (_selectShapeView) {
                if ([self.delegate respondsToSelector:@selector(yxAnnotationView:didChangeShapeView:)]) {
                    [self.delegate yxAnnotationView:self didChangeShapeView:_selectShapeView];
                }
                return;
            }

            if ([self.delegate respondsToSelector:@selector(yxAnnotationView:didCreateShapeView:)]) {
                [self.delegate yxAnnotationView:self didCreateShapeView:_currentShapeView];
            }
            self.selectShapeView = _currentShapeView;
            [_shapeViews addObject:_currentShapeView];
            _currentShapeView = nil;
            break;
        }
        default:
            break;
    }
    
    
}


#pragma mark -

- (void)setShapeViewFrame:(YXAnnotationShapeView *)shapeView offSet:(CGPoint)point {

    if (_editType == EditTypeOfMove) {
       
        CGRect frame = shapeView.frame;
        CGFloat x, y, h, w;
        
       
        x = frame.origin.x;
        y = frame.origin.y;
        
        w = frame.size.width;
        h = frame.size.height;
        
        CGRect newRect = CGRectOffset(shapeView.frame, point.x, point.y);
        
        if (newRect.origin.x < _imageView.frame.origin.x) {
            x = _imageView.frame.origin.x;
        } else if (newRect.origin.x > CGRectGetMaxX(_imageView.frame) - newRect.size.width) {
            x = CGRectGetMaxX(_imageView.frame) - newRect.size.width;
        } else {
            x = newRect.origin.x;
        }
        
        if (newRect.origin.y < _imageView.frame.origin.y) {
            y = _imageView.frame.origin.y;
        } else if (newRect.origin.y > CGRectGetMaxY(_imageView.frame) - newRect.size.height) {
            y = CGRectGetMaxY(_imageView.frame) - newRect.size.height;
        } else {
            y = newRect.origin.y;
        }
        
        shapeView.frame = CGRectMake(x, y, w, h);
        return;
        
    }
    
    CGPoint point1, point2;
    CGFloat nx, ny;

    nx = shapeView.brPoint.x + point.x;
    ny = shapeView.brPoint.y + point.y;
    
    point1 = [self getLimitedPointWithPoint:CGPointMake(nx, ny) shapeView:shapeView];
    point2 = shapeView.tlPoint;
    
    shapeView.brPoint = point1;

    shapeView.frame = [self getRectWithLPoint:point1 rPoint:point2];
}

- (CGPoint)getLimitedPointWithPoint:(CGPoint)point shapeView:(YXAnnotationShapeView *)view {
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    
    if (x < _imageView.frame.origin.x) {
        x = _imageView.frame.origin.x;
    } else if (x > CGRectGetMaxX(_imageView.frame)) {
        x = CGRectGetMaxX(_imageView.frame);
    }
    
    if (y < _imageView.frame.origin.y) {
        y = _imageView.frame.origin.y;
    } else if (y > CGRectGetMaxY(_imageView.frame)) {
        y = CGRectGetMaxY(_imageView.frame);
    }
    
    return CGPointMake(x, y);
}



- (CGPoint)pointWithOriginPoint:(CGPoint)point {
    
    CGRect transfromedImageViewRect = _imageView.frame;
    
    CGFloat x;
    CGFloat y;
    
    if (point.x < CGRectGetMinX(transfromedImageViewRect)) {
        x = CGRectGetMinX(transfromedImageViewRect);
    } else if (point.x > CGRectGetMaxX(transfromedImageViewRect)) {
        x = CGRectGetMaxX(transfromedImageViewRect);
    } else {
        x = point.x;
    }
    
    if (point.y < CGRectGetMinY(transfromedImageViewRect)) {
        y = CGRectGetMinY(transfromedImageViewRect);
    } else if (point.y > CGRectGetMaxY(transfromedImageViewRect)) {
        y = CGRectGetMaxY(transfromedImageViewRect);
    } else {
        y = point.y;
    }
    
    return CGPointMake(x, y);
}


#pragma mark - setting

- (void)setSelectShapeView:(YXAnnotationShapeView *)selectShapeView {
    
    if (selectShapeView == _selectShapeView) {
        return;
    }

    // 旧的
    _selectShapeView.showEditBox = NO;
    _selectShapeView = selectShapeView;
    if (selectShapeView) {
        // 新的
        _selectShapeView.showEditBox = YES;
        if ([self.delegate respondsToSelector:@selector(yxAnnotationView:didSelectShapeView:)]) {
            [self.delegate yxAnnotationView:self didSelectShapeView:_selectShapeView];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(yxAnnotationViewTapBlankArea:)]) {
            [self.delegate yxAnnotationViewTapBlankArea:self];
        }
    }
}

- (void)setColor:(UIColor *)color {
    
    _color = color;
    
    if (_selectShapeView) {
        
        [_selectShapeView setColor:color frame:_selectShapeView.frame annotationType:_selectShapeView.type];
        if ([self.delegate respondsToSelector:@selector(yxAnnotationView:didChangeShapeView:)]) {
            [self.delegate yxAnnotationView:self didChangeShapeView:_selectShapeView];
        }
    }
}

- (void)setType:(AnnotationType)type {
    
    _type = type;
    
    if (_selectShapeView) {
        [_selectShapeView setColor:_color frame:_selectShapeView.frame annotationType:_type];
        if ([self.delegate respondsToSelector:@selector(yxAnnotationView:didChangeShapeView:)]) {
            [self.delegate yxAnnotationView:self didChangeShapeView:_selectShapeView];
        }
    }
    
}

#pragma mark - private



- (YXAnnotationShapeView *)getShapeViewWithPoint:(CGPoint)point {
    
    for (YXAnnotationShapeView *view in _shapeViews) {
        if (view.superview && [view containPoint:[self convertPoint:point toView:view]]) { // 点击
            return view;
        }
    }
    return nil;
}

- (YXAnnotationShapeView *)addShapeView {
    
    YXAnnotationShapeView *shapeView = [[YXAnnotationShapeView alloc] initWithType:_type
                                                                             color:_color];
    [self addSubview:shapeView];
    
    return shapeView;
}

- (CGRect)getRectWithLPoint:(CGPoint)lpoint rPoint:(CGPoint)rPoint {
    
    CGFloat x = MIN(lpoint.x, rPoint.x);
    CGFloat y = MIN(lpoint.y, rPoint.y);
    
    return CGRectMake(x, y, fabs(lpoint.x - rPoint.x), fabs(lpoint.y - rPoint.y));

}


@end

