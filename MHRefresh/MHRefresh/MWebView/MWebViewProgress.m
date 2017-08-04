//
//  MWebViewProgress.m
//  Memory
//
//  Created by developer on 17/2/15.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

/**
 *  NJKWebViewProgress.h
 */
#import "MWebViewProgress.h"
#import <UIKit/UIKit.h>

NSString *completeRPCURLPath = @"/mkwebviewprogressproxy/complete";

CGFloat const kInitialProgressValue = 0.1f;
CGFloat const kInteractiveProgressValue = 0.5f;
CGFloat const kFinalProgressValue = 0.9f;

@interface MWebViewProgress()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) NSUInteger loadingCount;

@property (nonatomic, assign) NSUInteger maxLoadCount;

@property (nonatomic, assign) NSURL *currentUrl;

@property (nonatomic, assign) BOOL interactive;

@end

@implementation MWebViewProgress

- (instancetype)init {
    
    if (self = [super init]) {
        _maxLoadCount = _loadingCount = 0;
        _interactive = NO;
    }
    return self;
}

- (void)startProgress {
    if (_progress < kInitialProgressValue) {
        [self setProgress:kInitialProgressValue];
    }
}

- (void)incrementProgress
{
    CGFloat progress = _progress;
    CGFloat maxProgress = _interactive ? kFinalProgressValue : kInteractiveProgressValue;
    CGFloat remainPercent = (CGFloat)_loadingCount / (CGFloat)_maxLoadCount;
    CGFloat increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)dealloc {
    //DLog(@"%@ dealloc", self);
}

- (void)completeProgress {
    [self setProgress:1.0];
}

- (void)setProgress:(CGFloat)progress {
    if (progress > _progress || progress == 0) {
        _progress = progress;
        
        if ([_webViewProgressDelegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
            [_webViewProgressDelegate webViewProgress:self updateProgress:progress];
        }
    }
}

- (void)reset {
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.path isEqualToString:completeRPCURLPath]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL ret = YES;
    
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentUrl = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }
    
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentUrl && [_currentUrl isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    } else if (complete) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentUrl && [_currentUrl isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if ((complete && isNotRedirect) || error) {
        [self completeProgress];
    }
}

#pragma mark Method Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    if ([self.webViewProxyDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (!signature) {
        
        if ([_webViewProxyDelegate respondsToSelector:selector]) {
            return [(NSObject *)_webViewProxyDelegate methodSignatureForSelector:selector];
        }
    }

    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation {
    
    if ([_webViewProxyDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_webViewProxyDelegate];
    }
    
}

@end
