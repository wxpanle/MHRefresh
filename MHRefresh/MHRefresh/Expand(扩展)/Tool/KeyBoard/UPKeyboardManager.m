//
//  UPKeyboardManager.m
//  Up
//
//  Created by panle on 2018/4/13.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPKeyboardManager.h"

@interface UPKeyboardManager () {
    NSHashTable *_observesTable;
    NSNotification *_kbShowNotification;
    CGSize _kbSize;
}

@property (nonatomic, assign) UIViewAnimationCurve animationCurve;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation UPKeyboardManager

#pragma mark - ===== init =====

+ (instancetype)defaultManager {
    
    static dispatch_once_t onceToken;
    static UPKeyboardManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _observesTable = [NSHashTable weakObjectsHashTable];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

#pragma mark - ===== public =====

- (void)up_appendKeyboardDelegate:(__weak id <UPKeyboardDelegate>)delegate {
    
    if ([delegate conformsToProtocol:@protocol(UPKeyboardDelegate)] &&
        ![_observesTable containsObject:delegate]) {
        [_observesTable addObject:delegate];
    }
}

- (void)up_removeAudioSessionDelegate:(__weak id <UPKeyboardDelegate>)delegate {
    if ([_observesTable containsObject:delegate]) {
        [_observesTable removeObject:delegate];
    }
}


#pragma mark - ===== NotificationCenter =====

-(void)p_keyboardWillShow:(NSNotification*)aNotification {
    
    _kbShowNotification = aNotification;
    
    _showing = YES;
    
    _animationCurve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    CGFloat duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (duration != 0.0)   {
        _animationDuration = duration;
    }
    
    CGSize oldKBSize = _kbSize;
    
    CGRect kbFrame = [[aNotification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
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
    
    if (!CGSizeEqualToSize(_kbSize, oldKBSize)) {
        dispatch_async_main_safe(^{
            for (id <UPKeyboardDelegate> delegate in _observesTable) {
                if ([delegate respondsToSelector:@selector(up_keyBoardWillShow)]) {
                    [delegate up_keyBoardWillShow];
                }
            }
        });
    }
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardWillShow endTime = %f", endTime - startTime);
#endif
}

/*  UIKeyboardDidShowNotification. */
- (void)p_keyboardDidShow:(NSNotification*)aNotification {
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif
    
    //In case of form sheet or page sheet, we'll add adjustFrame call in main queue to perform it when UI thread will do all framing updation so adjustFrame will be executed after all internal operations.
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

        CGFloat height = _kbSize.height;
        NSTimeInterval duration = _animationDuration;
        UIViewAnimationOptions options = _animationCurve | UIViewAnimationOptionBeginFromCurrentState;
        
        for (id <UPKeyboardDelegate> delegate in _observesTable) {
            
            if ([delegate respondsToSelector:@selector(up_keyBoardDidShowAnimationHeight:duration:options:)]) {
                [delegate up_keyBoardDidShowAnimationHeight:height duration:duration options:options];
            }
        }
    }];
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardDidShow endTime = %f", endTime - startTime);
#endif
}

/*  UIKeyboardWillHideNotification. So setting rootViewController to it's default frame. */
- (void)p_keyboardWillHide:(NSNotification*)aNotification {
    
    if (aNotification != nil) {
        _kbShowNotification = nil;
    }
    
    //  Boolean to know keyboard is showing/hiding
    _showing = NO;
    
    //  Getting keyboard animation duration
    CGFloat aDuration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (aDuration != 0.0f) {
        _animationDuration = aDuration;
    }
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif

    CGFloat height = _kbSize.height;
    NSTimeInterval duration = _animationDuration;
    UIViewAnimationOptions options = _animationCurve | UIViewAnimationOptionBeginFromCurrentState;

    dispatch_async_main_safe(^ {
        for (id <UPKeyboardDelegate> delegate in _observesTable) {
            
            if ([delegate respondsToSelector:@selector(up_keyBoardWillHideHeight:duration:options:)]) {
                [delegate up_keyBoardWillHideHeight:height duration:duration options:options];
            }
        }
    });
    
    _kbSize = CGSizeZero;
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardWillHide endTime = %f", endTime - startTime);
#endif
}

/*  UIKeyboardDidHideNotification. */
- (void)p_keyboardDidHide:(NSNotification*)aNotification {
    
#if DEBUG
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif
    
    dispatch_async_main_safe(^ {
        for (id <UPKeyboardDelegate> delegate in _observesTable) {
            
            if ([delegate respondsToSelector:@selector(up_keyBoardDidHide)]) {
                [delegate up_keyBoardDidHide];
            }
        }
    });
    
    _kbSize = CGSizeZero;
    
#if DEBUG
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    DLog(@"keyboardDidHide endTime = %f", endTime - startTime);
#endif
}

#pragma mark - ===== private =====

- (void)p_removeObserves {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ===== dealloc =====

- (void)dealloc {
    [self p_removeObserves];
    DLOG_DEALLOC
}

@end
