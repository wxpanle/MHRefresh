//
//  QYKeyBoardManager.h
//  MHRefresh
//
//  Created by developer on 2017/10/30.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QYKeyBoardManagerDelegate <NSObject>

- (void)keyBoardWillShow;

- (void)keyBoardDidShowHeight:(CGFloat)height animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)keyBoardWillHideHeight:(CGFloat)height animationDuration:(NSTimeInterval)animationDuration animationCurve:(UIViewAnimationCurve)animationCurve;

- (void)keyBoardDidHide;

@end

@interface QYKeyBoardManager : NSObject

@property (nonatomic, weak) id <QYKeyBoardManagerDelegate> delegate;

@property(nonatomic, assign, readonly, getter = isKeyboardShowing) BOOL  keyboardShowing;

@end
