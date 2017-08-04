//
//  MWebLinkLoadingView.m
//  Memory
//
//  Created by developer on 17/2/15.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MWebLinkLoadingView.h"

@interface MWebLinkLoadingView()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) UIView *tintColorView;

@property (nonatomic, assign) CGFloat kTintColorViewAnimationDuration;

@property (nonatomic, assign) CGFloat kTintColorViewFadeAnimationDuration;

@property (nonatomic, assign) CGFloat kTintColorViewFadeOutDelay;

@end

@implementation MWebLinkLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    
    return self;
}

- (void)dealloc {
    //DLog(@"%@ dealloc", self);
}

- (void)layoutUI {
    
    {
        //self
        self.userInteractionEnabled = NO;
    }
    
    {
        //tintColorView
        self.tintColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2.0)];
        self.tintColorView.userInteractionEnabled = NO;
        self.tintColorView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.tintColorView];
    }
    
    {
        self.kTintColorViewAnimationDuration = 0.27;
        self.kTintColorViewFadeAnimationDuration = 0.27;
        self.kTintColorViewFadeOutDelay = 0.1f;
    }
}

-(void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    BOOL isGrowing = progress > 0.0;
    
    [UIView animateWithDuration:(isGrowing && animated) ? self.kTintColorViewAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.tintColorView.frame;
        frame.size.width = progress * self.bounds.size.width;
        self.tintColorView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? self.kTintColorViewFadeAnimationDuration : 0.0 delay:self.kTintColorViewFadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tintColorView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.tintColorView.frame;
            frame.size.width = 0;
            self.tintColorView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:animated ? self.kTintColorViewFadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tintColorView.alpha = 1.0;
        } completion:nil];
    }
}

- (void)webViewProgress:(MWebViewProgress *)webViewProgress updateProgress:(CGFloat)progress {
    [self setProgress:progress animated:YES];
}

@end
