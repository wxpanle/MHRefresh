//
//  MWebView.m
//  Memory
//
//  Created by developer on 17/4/11.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MWebView.h"
#import <WebKit/WebKit.h>
#import <Availability.h>
#import "MWebViewheader.h"
#import "MWebViewProgress.h"
#import "MWebLinkLoadingView.h"

typedef NS_ENUM(NSInteger, LoadType) {
    LoadTypeHtmlString,
    LoadTypeUrlString,
};

@interface MWebView() <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, assign) LoadType loadType;

@property (nonatomic, strong) __kindof UIView *webView;

@property (nonatomic, strong) UIProgressView *wkWebViewProgressView;

@property (nonatomic, strong) MWebViewProgress *uiWebViewProgressView;

@property (nonatomic, strong) MWebLinkLoadingView *webLinkLoadingView;

@property (nonatomic, strong) NSURLRequest *request;

@property (nonatomic, assign) CGFloat delayTime;

@property (nonatomic, assign) BOOL isNeedProgress;

@property (nonatomic, assign) BOOL isAllowWebViewScroll;

@property (nonatomic, strong) NSMutableDictionary *didFinishLoadCpmpleteDict;

@property (nonatomic, assign) BOOL isLoadCpmplete;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation MWebView

#pragma mark - init
- (instancetype _Nonnull)initWithFrame:(CGRect)frame andHtmlString:(NSString *_Nonnull)htmlString {
    if (self = [super initWithFrame:frame]) {
        self.htmlString = htmlString;
        self.loadType = LoadTypeHtmlString;
        _isAllowWebViewScroll = YES;
    }
    return self;
}

- (instancetype _Nonnull)initWithFrame:(CGRect)frame andRequestUrl:(NSURL *_Nonnull)url {
    if (self = [super initWithFrame:frame]) {
        self.urlString = url.absoluteString;
        self.loadType = LoadTypeUrlString;
        _isAllowWebViewScroll = YES;
    }
    return self;
}

- (instancetype _Nonnull)initWithFrame:(CGRect)frame andRequestUrlString:(NSString *_Nonnull)urlString {
    if (self = [super initWithFrame:frame]) {
        self.urlString = urlString;
        self.loadType = LoadTypeUrlString;
        _isAllowWebViewScroll = YES;
    }
    return self;
}

#pragma mark - UI
- (void)layoutUIOfWebView {
    [self addSubview:self.webView];
    [self layoutUIOfObserves];
    [self layoutUIOfProgressView];
}

- (void)layoutUIOfProgressView {
    
    if (!_isNeedProgress) {
        return;
    }
    
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [self addSubview:self.wkWebViewProgressView];
    } else {
        [self layoutUIOfWebLinkLoadingView];
        [self layoutUIOfWebViewProgress];
    }
}

- (void)layoutUIOfObserves {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView *)self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [(WKWebView *)self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [((WKWebView *)self.webView).scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (UIView *)webView {
    if (_webView == nil) {
        switch (self.loadType) {
            case LoadTypeUrlString: {
                _webView = [self getWkWebView];
            }
                break;
                
            case LoadTypeHtmlString: {
                if (IS_IOS_NINE_POINT_ZERO_LATER) {
                    _webView = [self getWkWebView];
                    ((WKWebView *)_webView).scrollView.scrollEnabled = _isAllowWebViewScroll;
                } else {
                    _webView = [self getWebView];
                    ((UIWebView *)_webView).scrollView.scrollEnabled = _isAllowWebViewScroll;
                }
                
                [self addTapGestureRecognizer];
                [self addLongPressGestureRecognizer];
            }
                break;
                
            default:
                break;
        }
    }
    
    return _webView;
}

#pragma mark - UIWebView
- (void)layoutUIOfWebViewProgress {
    ((UIWebView *)self.webView).delegate = self.uiWebViewProgressView;
}

- (void)layoutUIOfWebLinkLoadingView {
    [self addSubview:self.webLinkLoadingView];
}

- (UIView *)progressView {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        return self.wkWebViewProgressView;
    } else {
        [self.webLinkLoadingView class];
        [self layoutUIOfWebLinkLoadingView];
        [self layoutUIOfWebViewProgress];
        return self.webLinkLoadingView;
    }
}

- (UIWebView *)getWebView {
    UIWebView *webView = nil;
    webView = [[UIWebView alloc] initWithFrame:self.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.scrollView.alwaysBounceVertical = YES;
    webView.scrollView.scrollEnabled = NO;
    return webView;
}

- (MWebLinkLoadingView *)webLinkLoadingView {
    if (_webLinkLoadingView == nil) {
        _webLinkLoadingView = [[MWebLinkLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2.0)];
    }
    return _webLinkLoadingView;
}

- (MWebViewProgress *)uiWebViewProgressView {
    if (_uiWebViewProgressView == nil) {
        _uiWebViewProgressView = [[MWebViewProgress alloc] init];
        _uiWebViewProgressView.webViewProgressDelegate = self.webLinkLoadingView;
        _uiWebViewProgressView.webViewProxyDelegate = self;
    }
    return _uiWebViewProgressView;
}

#pragma mark - WKWebView
- (WKWebView *)getWkWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKProcessPool *processPool = [[WKProcessPool alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = [UIFont systemFontSize];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    if (IS_IOS_NINE_POINT_ZERO_LATER) {
        WKWebsiteDataStore *websiteDataStore = [WKWebsiteDataStore defaultDataStore];
        configuration.websiteDataStore = websiteDataStore;
    }
    configuration.processPool = processPool;
    configuration.preferences = preferences;
    configuration.userContentController = userContentController;
    configuration.allowsInlineMediaPlayback = YES;
    
    if (IS_IOS_TEN_POINT_ZERO_LATER) {
        configuration.dataDetectorTypes = WKDataDetectorTypeNone;
    }
    
    WKWebView *webView = nil;
    if (self.loadType == LoadTypeHtmlString) {
        webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    } else {
        webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    }
    webView.backgroundColor = [UIColor whiteColor];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [webView sizeToFit];
    return webView;
}

- (UIProgressView *)wkWebViewProgressView {
    if (_wkWebViewProgressView == nil) {
        _wkWebViewProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2.0)];
        _wkWebViewProgressView.progressTintColor = [UIColor greenColor];
        _wkWebViewProgressView.trackTintColor = [UIColor lightTextColor];
    }
    return _wkWebViewProgressView;
}

- (void)removeObserves {
    if (_webView && [_webView isKindOfClass:[WKWebView class]]) {
        
        @try {
            [(WKWebView *)_webView removeObserver:self forKeyPath:@"title"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        @try {
            [(WKWebView *)_webView removeObserver:self forKeyPath:@"estimatedProgress"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        @try {
            [((WKWebView *)_webView).scrollView removeObserver:self forKeyPath:@"contentSize"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

#pragma mark - public method
- (void)setIsNeedProgress:(BOOL)is {
    _isNeedProgress = is;
}

- (void)setIsAllowWebViewScroll:(BOOL)is {
    _isAllowWebViewScroll = is;
}

- (void)updateWebViewFrame:(CGRect)frame {
    self.webView.frame = frame;
}

- (void)updateSelfFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.frame, frame)) {
        return;
    }
    self.frame = frame;
    if (frame.size.height > self.webView.frame.size.height) {
        
    } else {
        self.webView.frame = self.bounds;
    }
    if ([_webView isKindOfClass:[UIWebView class]]) {
        CGFloat height = [self getUIWebViewHeightWithWebView:_webView];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewHeightChange:andMWebView:)]) {
                [self.delegate mWebViewHeightChange:height andMWebView:self];
            }
        });
    }
}

- (void)resetUpdateFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.frame, frame)) {
        return;
    }
    self.frame = frame;
    self.webView.frame = self.bounds;
}

- (CGFloat)getCurrentWebViewHeight {
    if (_webView) {
        if ([_webView isKindOfClass:[WKWebView class]]) {
            return ((WKWebView *)_webView).scrollView.contentSize.height;
        } else {
            if ([self isLoading]) {
                return 0.0;
            }
            return [self getUIWebViewHeightWithWebView:((UIWebView *)_webView)];
        }
    }
    return 0.0;
}

- (void)resetHtmlString:(NSString * _Nonnull)htmlString {
    self.htmlString = htmlString;
    self.loadType = LoadTypeHtmlString;
    _isLoadCpmplete = NO;
    [self startLoadData];
}

- (void)resetUrl:(NSURL * _Nonnull)url {
    self.urlString = url.absoluteString;
    self.loadType = LoadTypeUrlString;
    _isLoadCpmplete = NO;
    [self startLoadData];
}

- (void)resetUrlString:(NSString * _Nonnull)urlString {
    self.urlString = urlString;
    self.loadType = LoadTypeUrlString;
    _isLoadCpmplete = NO;
    [self startLoadData];
}

- (void)startLoadData {
    
    if (_wkWebViewProgressView.hidden) {
        _wkWebViewProgressView.hidden = NO;
    }
    
    if (_webView == nil) {
        [self layoutUIOfWebView];
    }
    
    if ([self isLoading]) {
        return;
    }
    
    if (_isLoadCpmplete) {
        return;
    }

    switch (self.loadType) {
        case LoadTypeUrlString: {
            if (nil == self.urlString) {
                return;
            }
            NSURL *url = [NSURL URLWithString:self.urlString];
            self.request = [NSURLRequest requestWithURL:url];
            [(WKWebView *)self.webView loadRequest:self.request];
        }
            break;
            
        case LoadTypeHtmlString: {
            if (nil == self.htmlString) {
                return;
            }
            
            if ([self.webView isKindOfClass:[WKWebView class]]) {
                [(WKWebView *)self.webView loadHTMLString:self.htmlString baseURL:nil];
            } else {
                [(UIWebView *)self.webView loadHTMLString:self.htmlString baseURL:nil];
            }
            
        }
            break;

        default:
            break;
    }
}

- (void)stopLoadData {
    if (_webView && [self isLoading]) {
        [self.webView stopLoading];
    }
}

- (BOOL)isLoading {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        return ((WKWebView *)self.webView).isLoading;
    }
    return ((UIWebView *)self.webView).isLoading;
}

- (BOOL)canGoBack {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        return ((WKWebView *)self.webView).canGoBack;
    }
    return ((UIWebView *)self.webView).canGoBack;
}

- (BOOL)canGoForward {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        return ((WKWebView *)self.webView).canGoForward;
    }
    return ((UIWebView *)self.webView).canGoForward;
}

- (void)goBack {
    [self stopLoadData];
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [((WKWebView *)self.webView) goBack];
    } else {
        [(UIWebView *)self.webView goBack];
    }
}

- (void)goForward {
    [self stopLoadData];
    if ([_webView isKindOfClass:[WKWebView class]]) {
        [((WKWebView *)_webView) goForward];
    } else {
        [(UIWebView *)_webView goForward];
    }
}

- (void)refresh {
    [self stopLoadData];
    if (_isLoadCpmplete) {
        _isLoadCpmplete = NO;
    }
    
    [self startLoadData];
}

- (void)reload {
    [self stopLoadData];
    if ([_webView isKindOfClass:[WKWebView class]]) {
        [((WKWebView *)_webView) reload];
    } else {
        [(UIWebView *)_webView reload];
    }
}

- (void)reloadFromOrigin {
    [self stopLoadData];
    if ([_webView isKindOfClass:[WKWebView class]]) {
        [((WKWebView *)_webView) reloadFromOrigin];
    } else {
        if (self.request) {
            [self stopLoadData];
            [self startLoadData];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double newProgress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        double oldprogress = [[change objectForKey:NSKeyValueChangeOldKey] doubleValue];
        
        MemoryWeakSelf
        if (newProgress != oldprogress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.wkWebViewProgressView setProgress:newProgress animated:YES];
            });
        }
        
        if (newProgress < 1.0) {
            weakSelf.delayTime = 1 - newProgress;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.wkWebViewProgressView.hidden = YES;
            weakSelf.wkWebViewProgressView.progress = 0;
        });
    } else if ([keyPath isEqualToString:@"title"]) {
        MemoryWeakSelf
        NSString *newTitle = [change objectForKey:NSKeyValueChangeNewKey];
        NSString *oldTitle = [change objectForKey:NSKeyValueChangeOldKey];
        if (![newTitle isEqualToString:oldTitle]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mWebViewTitleChange: andMWebView:)]) {
                    [weakSelf.delegate mWebViewTitleChange:newTitle andMWebView:weakSelf];
                }
            });
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        MemoryWeakSelf
        CGSize newSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
        CGSize oldSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
        if (!CGSizeEqualToSize(newSize, oldSize)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mWebViewHeightChange: andMWebView:)]) {
                    [weakSelf.delegate mWebViewHeightChange:newSize.height andMWebView:weakSelf];
                }
            });
        }
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL isAllow = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDecidePolicyForNavigationAction:andMWebView:)]) {
        isAllow = [self.delegate mWebViewDecidePolicyForNavigationAction:request andMWebView:self];
    }
    return isAllow;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidStartLoadMWebView:)]) {
        [self.delegate mWebViewDidStartLoadMWebView:self];
    }
    
    self.isLoadCpmplete = NO;
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewTitleChange:andMWebView:)]) {
        [self.delegate mWebViewTitleChange:string andMWebView:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIWebView setUserDefaults];

    NSString *javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
                  viewPortTag.id='viewport';  \
                  viewPortTag.name = 'viewport';  \
                  viewPortTag.content = 'width=%f; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
                  document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , self.bounds.size.width];
    
    [webView stringByEvaluatingJavaScriptFromString:javascript];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidFinishMWebView:)]) {
        [self.delegate mWebViewDidFinishMWebView:self];
    }
    CGFloat height = [self getUIWebViewHeightWithWebView:webView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewHeightChange:andMWebView:)]) {
            [self.delegate mWebViewHeightChange:height andMWebView:self];
        }
    });
   self.isLoadCpmplete = YES;
}

- (CGFloat)getUIWebViewHeightWithWebView:(UIWebView *)webView {
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    return height + 1;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidFailNavigationWithError:andMWebView:)]) {
        [self.delegate mWebViewDidFailNavigationWithError:error andMWebView:self];
    }
}


//protocol can provide methods for tracking progress for main frame navigations and for deciding policy for main frame and subframe navigations.
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //DLog(@"发送某个请求之前 是否允许跳转");
    BOOL isAllow = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDecidePolicyForNavigationAction: andMWebView:)]) {
        isAllow = [self.delegate mWebViewDecidePolicyForNavigationAction:navigationAction.request andMWebView:self];
    }
    WKNavigationActionPolicy navigationActionPolicy = isAllow == YES ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
    decisionHandler(navigationActionPolicy);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //DLog(@"在收到相应后是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    //NSLog(@"开始加载");
    self.isLoadCpmplete = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidStartLoadMWebView:)]) {
        [self.delegate mWebViewDidStartLoadMWebView:self];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    //NSLog(@"收到服务重定向");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //NSLog(@"数据记载错误");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidCommitFailWithError: andMWebView:)]) {
        [self.delegate mWebViewDidCommitFailWithError:error andMWebView:self];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    //NSLog(@"开始获取到网页内容");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidCommitMWebView:)]) {
        [self.delegate mWebViewDidCommitMWebView:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //NSLog(@"网页加载结束");
    
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidFinishMWebView:)]) {
        [self.delegate mWebViewDidFinishMWebView:self];
    }
    CGFloat height = webView.scrollView.contentSize.height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewHeightChange:andMWebView:)]) {
            [self.delegate mWebViewHeightChange:height andMWebView:self];
        }
    });
    self.isLoadCpmplete = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //NSLog(@"网页获取失败");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewDidFailNavigationWithError:andMWebView:)]) {
        [self.delegate mWebViewDidFailNavigationWithError:error andMWebView:self];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    //NSLog(@"收到来自网页的请求证书验证");
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    //NSLog(@"网页进程即将终止");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewWebContentProcessDidTerminateMWebView:)]) {
        [self.delegate mWebViewWebContentProcessDidTerminateMWebView:self];
    }
}

//protocol provides methods for presenting native UI on behalf of a webpage
#pragma mark - WKUIDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    //NSLog(@"创建一个新的WebView");
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    //NSLog(@"关闭webView时调用");
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    //NSLog(@"弹出了一个警告框");
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    //NSLog(@"弹出了一个确认框");
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    //NSLog(@"输入框");
}


- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0)) {
    //NSLog(@"webView是否可以预览元素");
    return YES;
}

- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0)) {
    //NSLog(@"可以定制你的预览控制器");
    return nil;
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0)) {
    //NSLog(@"允许你的app弹出试图控制器");
}


//protocol provides amethod for receiving messages from JavaScript running in a webpage
#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //NSLog(@"收到来自网页端的信息");
    //js  交互
}

- (void)dealloc {
    [self stopLoadData];
    if (_webView != nil) {
        [self removeObserves];
        if ([_webView isKindOfClass:[UIWebView class]]) {
            ((UIWebView *)_webView).delegate = nil;
        }
    }
    _webView = nil;
    NSLog(@"%@ dealloc", self);
}

#pragma mark - GestureRecognizer
- (void)addTapGestureRecognizer {
    [self.webView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)addLongPressGestureRecognizer {
    [self.webView addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    //NSLog(@"处理点击手势");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(mWebViewTapGestureRecognizer)]) {
            [self.delegate mWebViewTapGestureRecognizer];
        }
    });
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    //NSLog(@"处理长按手势");
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [longPressGestureRecognizer locationInView:self.webView];
        NSString *imgJs = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        
        if ([_webView isKindOfClass:[UIWebView class]]) {
            [self handleLongPressGestureRecognizerOfUIWebView:imgJs andPoint:touchPoint];
            return;
        }
        
        if ([_webView isKindOfClass:[WKWebView class]]) {
            [self handleLongPressGestureRecognizerOfWKWebView:imgJs andPoint:touchPoint];
            return;
        }
        
        NSLog(@"webView 不存在");
    }

}

- (void)handleLongPressGestureRecognizerOfUIWebView:(NSString *)imgJs andPoint:(CGPoint)point {
    NSString *url = [_webView stringByEvaluatingJavaScriptFromString:imgJs];
    if (url.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = [(UIWebView *)_webView elementFrameWithPoint:point];
        [self callBackOfLongPressGestureRecognizer:url andPoint:frame];
    });
}

- (void)handleLongPressGestureRecognizerOfWKWebView:(NSString *)imgeJs andPoint:(CGPoint)point{
    // 执行对应的JS代码 获取url
    MemoryWeakSelf
    [self.webView evaluateJavaScript:imgeJs completionHandler:^(id _Nullable url, NSError * _Nullable error) {
        if (url) {
            NSLog(@"图片存在 %@", url);
            dispatch_async(dispatch_get_main_queue(), ^{
                [(WKWebView *)weakSelf.webView elementFrameWithPoint:point callBlock:^(CGRect frame) {
                    [weakSelf callBackOfLongPressGestureRecognizer:url andPoint:frame];
                }];
            });
        }
    }];
}

- (void)callBackOfLongPressGestureRecognizer:(NSString *)url andPoint:(CGRect)frame {
    MemoryWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mWebViewlongPressGestureRecognizerWithUrl:andFrame:)]) {
            [weakSelf.delegate mWebViewlongPressGestureRecognizerWithUrl:url andFrame:frame];
        }
    });
}

#pragma mark gestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer == self.tapGestureRecognizer) {
        return NO;
    }
    return YES;
}

- (void)manualTriggerLongPressWatchOriginImgae {
    CGPoint touchPoint = CGPointMake(self.width / 2.0, self.height / 4.0);
    NSString *imgJs = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    if ([_webView isKindOfClass:[UIWebView class]]) {
        [self handleLongPressGestureRecognizerOfUIWebView:imgJs andPoint:touchPoint];
        return;
    }
    
    if ([_webView isKindOfClass:[WKWebView class]]) {
        [self handleLongPressGestureRecognizerOfWKWebView:imgJs andPoint:touchPoint];
        return;
    }
}


#pragma mark - helper
- (NSMutableDictionary *)didFinishLoadCpmpleteDict {
    if (nil == _didFinishLoadCpmpleteDict) {
        _didFinishLoadCpmpleteDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _didFinishLoadCpmpleteDict;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (nil == _tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        _tapGestureRecognizer.delegate = self;
        [_tapGestureRecognizer requireGestureRecognizerToFail:self.longPressGestureRecognizer];
    }
    return _tapGestureRecognizer;
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (nil == _longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        _longPressGestureRecognizer.minimumPressDuration = 0.3;
        _longPressGestureRecognizer.delegate = self;
    }
    return _longPressGestureRecognizer;
}

@end
