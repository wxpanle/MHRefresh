//
//  QYKeyBoardManager.m
//  MHRefresh
//
//  Created by developer on 2017/10/30.
//  Copyright © 2017年 developer. All rights reserved.
//

///-------------------------------
/// @name IQKeyBoardManager
///-------------------------------

#import "QYKeyBoardManager.h"

@interface QYKeyBoardManager() {
    NSNotification *_kbShowNotification;
    CGSize _kbSize;
}

@property (nonatomic, assign) UIViewAnimationCurve animationCurve;

@property (nonatomic, assign) NSTimeInterval animationDuration;


@end

@implementation QYKeyBoardManager

- (instancetype)init {
    
    if (self = [super init]) {
        [self layoutOfObserves];
    }
    return self;
}

- (void)layoutOfObserves {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)removeObserves {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIKeyboad Notification methods
/*  UIKeyboardWillShowNotification. */
-(void)keyboardWillShow:(NSNotification*)aNotification {
    
    _kbShowNotification = aNotification;
    
    //  Boolean to know keyboard is showing/hiding
    _keyboardShowing = YES;
    
    //  Getting keyboard animation.
    _animationCurve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    //  Getting keyboard animation duration
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Saving animation duration
    if (duration != 0.0)   {
        _animationDuration = duration;
    }
    
    CGSize oldKBSize = _kbSize;
    
    //  Getting UIKeyboardSize.
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
    //CGRectIntersection(frame1, fram2) 判断区域一和区域二是否相交
    CGRect intersectRect = CGRectIntersection(kbFrame, screenSize);
    
    if (CGRectIsNull(intersectRect)) {
        _kbSize = CGSizeMake(screenSize.size.width, 0);
    } else {
        _kbSize = intersectRect.size;
    }
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    //If last restored keyboard size is different(any orientation accure), then refresh. otherwise not.
    if (!CGSizeEqualToSize(_kbSize, oldKBSize)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardWillShow)]) {
            [self.delegate keyBoardWillShow];
        }
    }
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardWillShow endTime = %f", endTime - startTime);
#endif
}

/*  UIKeyboardDidShowNotification. */
- (void)keyboardDidShow:(NSNotification*)aNotification {
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    //In case of form sheet or page sheet, we'll add adjustFrame call in main queue to perform it when UI thread will do all framing updation so adjustFrame will be executed after all internal operations.
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardDidShowHeight:animationDuration:animationCurve:)]) {
            //添加操作
            [self.delegate keyBoardDidShowHeight:_kbSize.height animationDuration:_animationDuration animationCurve:_animationCurve];
        }
    }];
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardDidShow endTime = %f", endTime - startTime);
#endif
}

/*  UIKeyboardWillHideNotification. So setting rootViewController to it's default frame. */
- (void)keyboardWillHide:(NSNotification*)aNotification {
    
    if (aNotification != nil) {
       _kbShowNotification = nil;
    }
    
    //  Boolean to know keyboard is showing/hiding
    _keyboardShowing = NO;
    
    //  Getting keyboard animation duration
    CGFloat aDuration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (aDuration != 0.0f) {
        _animationDuration = aDuration;
    }
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardWillHideHeight:animationDuration:animationCurve:)]) {
        [self.delegate keyBoardWillHideHeight:_kbSize.height animationDuration:_animationDuration animationCurve:_animationCurve];
    }

    _kbSize = CGSizeZero;
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardWillHide endTime = %f", endTime - startTime);
#endif
}

/*  UIKeyboardDidHideNotification. */
- (void)keyboardDidHide:(NSNotification*)aNotification {

#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardDidHide:)]) {
        [self.delegate keyBoardDidHide];
    }
    
    _kbSize = CGSizeZero;
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardDidHide endTime = %f", endTime - startTime);
#endif
}

- (void)dealloc {
    [self removeObserves];
    DLog(@"%@ dealloc", self);
}

@end
