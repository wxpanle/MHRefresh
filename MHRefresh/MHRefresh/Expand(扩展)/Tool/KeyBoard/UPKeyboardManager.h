//
//  UPKeyboardManager.h
//  Up
//
//  Created by panle on 2018/4/13.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UPKeyboardDelegate <NSObject>

@optional
- (void)up_keyBoardWillShow;
- (void)up_keyBoardDidHide;

- (void)up_keyBoardDidShowAnimationHeight:(CGFloat)height duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options;

- (void)up_keyBoardWillHideHeight:(CGFloat)height duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options;

@end

@interface UPKeyboardManager : NSObject

@property (nonatomic, assign, readonly, getter=isShowing) BOOL showing;

+ (instancetype)defaultManager;

/**
 添加一个 delegate

 @param delegate delegate <UPKeyboardDelegate>
 */
- (void)up_appendKeyboardDelegate:(__weak id <UPKeyboardDelegate>)delegate;

/**
 移除一个 delegate

 @param delegate delegate <UPKeyboardDelegate>
 */
- (void)up_removeAudioSessionDelegate:(__weak id <UPKeyboardDelegate>)delegate;


@end
