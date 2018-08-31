//
//  WKWebView+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "WKWebView+QYNightMode.h"

static NSString * kWKWebViewBackgroundHexColorKey = @"kWKWebViewBackgroundHexColorKey";
static NSString * kWKWebViewTextColorHexColorKey = @"kWKWebViewTextColorHexColorKey";

@implementation WKWebView (QYNightMode)

- (void)qy_switchNightMode {
    [super qy_switchNightMode];
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithString:kWKWebViewBackgroundHexColorKey nightMode:self.qy_nightNode]] != nil) {
            [self p_jsBackgroundHexColorWithColorString:[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithString:kWKWebViewBackgroundHexColorKey nightMode:self.qy_nightNode]]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithString:kWKWebViewTextColorHexColorKey nightMode:self.qy_nightNode]] != nil) {
            [self p_jsTextHexColorWithColorString:[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithString:kWKWebViewTextColorHexColorKey nightMode:self.qy_nightNode]]];
        }
        
    }];
}

- (void)qy_setBackgroundHexColorString:(NSString *)hexString withNightMode:(QYNightMode)mode {
    
    [self.qy_nightModeDictionary setObject:hexString forKey:[self qy_saveKeyWithString:kWKWebViewBackgroundHexColorKey nightMode:mode]];
}

- (void)qy_setTextColorHexColorString:(NSString *)hexString withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:hexString forKey:[self qy_saveKeyWithString:kWKWebViewTextColorHexColorKey nightMode:mode]];
}

#pragma mark - private

- (void)p_jsBackgroundHexColorWithColorString:(NSString *)colorString {
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#%@'", colorString];
    [self evaluateJavaScript:js completionHandler:nil];
}

- (void)p_jsTextHexColorWithColorString:(NSString *)colorString {
    
    for (NSString *control in [self p_jsControlStringArray]) {
        NSString *js = [NSString stringWithFormat:@"var i, a;"
                        "for(i = 0; (a = document.getElementsByTagName('%@')[i]); i ++) {"
                        "a.style.background = '#%@';"
                        "}", control, colorString];
        [self evaluateJavaScript:js completionHandler:nil];
    }
    
}
- (NSArray <NSString *>*)p_jsControlStringArray {
    static NSArray *jsControl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsControl = @[@"body",
                      @"div",
                      @"section",
                      @"ul",
                      @"li",
                      @"h1",
                      @"h2",
                      @"h3",
                      @"p",
                      @"link",
                      @"img",
                      ];
    });
    return [NSArray arrayWithArray:jsControl];
}

@end
