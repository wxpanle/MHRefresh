//
//  MWebView.h
//  Memory
//
//  Created by developer on 17/4/11.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWebView;

@protocol MWebViewLoadDelegate <NSObject>

@optional
/**
 * 网页标题发生改变 加载url请求实现  加载htmlString 不必实现
 */
- (void)mWebViewTitleChange:(NSString * _Nullable)title andMWebView:(MWebView * _Nullable)webView;

/**
 * 网页高度发生改变 加载htmlString 实现用于查看高度  如果加载url 固定高度下 可以不实现
 */
- (void)mWebViewHeightChange:(CGFloat)height andMWebView:(MWebView *_Nullable)webView;

/**
 * 是否跳转链接
 */
- (BOOL)mWebViewDecidePolicyForNavigationAction:(NSURLRequest * _Nullable)request andMWebView:(MWebView *_Nullable)webView;

/**
 * 加载开始
 */
- (void)mWebViewDidStartLoadMWebView:(MWebView *_Nullable)webView;

/**
 * 开始加载内容
 */
- (void)mWebViewDidCommitMWebView:(MWebView *_Nullable)webView;

/**
 * 加载内容失败
 */
- (void)mWebViewDidCommitFailWithError:(NSError * _Nullable)error andMWebView:(MWebView *_Nullable)webView;

/**
 * 加载结束
 */
- (void)mWebViewDidFinishMWebView:(MWebView *_Nonnull)webView;

/**
 * 跳转失败
 */
- (void)mWebViewDidFailNavigationWithError:(NSError * _Nullable)error andMWebView:(MWebView *_Nullable)webView;

/**
 * webView即将被清除
 */
- (void)mWebViewWebContentProcessDidTerminateMWebView:(MWebView * _Nullable)webView API_AVAILABLE(macosx(10.11), ios(9.0));

/**
 * 单机webView
 */
- (void)mWebViewTapGestureRecognizer;

/**
 * 长按WebView
 */
- (void)mWebViewlongPressGestureRecognizerWithUrl:(NSString * _Nonnull)url andFrame:(CGRect)frame;


@end

@interface MWebView : UIView

@property (nonatomic, weak) id <MWebViewLoadDelegate> _Nullable delegate;

@property (nonatomic, strong, readonly) __kindof UIView *_Nonnull webView;

- (instancetype _Nonnull)initWithFrame:(CGRect)frame andHtmlString:(NSString * _Nonnull)htmlString;

- (instancetype _Nonnull)initWithFrame:(CGRect)frame andRequestUrl:(NSURL * _Nonnull)url;

- (instancetype _Nonnull)initWithFrame:(CGRect)frame andRequestUrlString:(NSString * _Nonnull)urlString;

///-------------------------------
/// @name 辅助
///-------------------------------
/**
 手动触发长安手势 用于查看引导
 */
- (void)manualTriggerLongPressWatchOriginImgae;

- (CGFloat)getCurrentWebViewHeight;

///-------------------------------
/// @name 设置webView
///-------------------------------
- (void)resetUpdateFrame:(CGRect)frame;

- (void)updateSelfFrame:(CGRect)frame;

- (void)setIsNeedProgress:(BOOL)is;

- (void)setIsAllowWebViewScroll:(BOOL)is;

///-------------------------------
/// @name webView操作
///-------------------------------
- (void)startLoadData;

- (void)stopLoadData;

- (BOOL)isLoading;

- (BOOL)canGoBack;

- (BOOL)canGoForward;

- (void)goBack;

- (void)goForward;

- (void)refresh;

///-------------------------------
/// @name 重置数据
///-------------------------------
- (void)resetHtmlString:(NSString * _Nonnull)htmlString;

- (void)resetUrl:(NSURL * _Nonnull)url;

- (void)resetUrlString:(NSString * _Nonnull)urlString;

@end
