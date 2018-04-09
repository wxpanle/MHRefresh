//
//  WKWebView+MElementFrame.m
//  Memory
//
//  Created by developer on 17/5/8.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "WKWebView+MElementFrame.h"

@implementation WKWebView (MElementFrame)

- (void)elementFrameWithPoint:(CGPoint)point callBlock:(WKWebViewCallBack)block {
    __block CGFloat pageXoffset = 0.0;
    __block CGFloat pageYoffet = 0.0;
    __block CGFloat elementOffsetLeft = 0.0;
    __block CGFloat elemnrtOffsetTop = 0.0;
    __block CGFloat elementWidth = 0.0;
    __block CGFloat elementHeight = 0.0;
    
    __block NSInteger finishNumber = 0;
    void (^finishBlock)(void) = ^ {
        finishNumber++;
        
        if (finishNumber == 6) {
            if (block) {
                block(CGRectMake(elementOffsetLeft - pageXoffset, elemnrtOffsetTop - pageYoffet, elementWidth, elementHeight));
            }
        }
    };
    
    [self getWindowPageXOffsetCallBlock:^(CGFloat value) {
        pageXoffset = value;
        !finishBlock ? : finishBlock();
    }];
    
    [self getWindowPageYOffsetCallBlock:^(CGFloat value) {
        pageYoffet = value;
        !finishBlock ? : finishBlock();
    }];
    
    [self getOffsetTopWithPoint:point callBlock:^(CGFloat value) {
        elemnrtOffsetTop = value;
        !finishBlock ? : finishBlock();
    }];
    
    [self getOffsetLeftWithPoint:point callBlock:^(CGFloat value) {
        elementOffsetLeft = value;
        !finishBlock ? : finishBlock();
    }];
    
    [self getElementWidthWithPoint:point callBlock:^(CGFloat value) {
        elementWidth = value;
        !finishBlock ? : finishBlock();
    }];
    
    [self getElementHeightWithPoint:point callBlock:^(CGFloat value) {
        elementHeight = value;
        !finishBlock ? : finishBlock();
    }];
    
    
}

- (void)getOffsetTopWithPoint:(CGPoint)point callBlock:(WKWebViewElementCallBack)block {
    NSString * getTopStr =[NSString stringWithFormat:
                           @"var script = document.createElement('script');"
                           "script.type = 'text/javascript';"
                           "script.text = \"function getAbsTop(e){"
                           "var offsetTop=e.offsetTop;"
                           "if(e.offsetParent!=null){"
                           "offsetTop+=getAbsTop(e.offsetParent);"
                           "}"
                           "return offsetTop;"
                           "};"
                           "function getTop(){"
                           "var ele = document.elementFromPoint(%f,%f);"
                           "return getAbsTop(ele);"
                           "}\";"
                           "document.getElementsByTagName('head')[0].appendChild(script);", point.x, point.y];
    
    [self evaluateJavaScript:getTopStr completionHandler:nil];
    
    NSString *str = @"getTop()";
    [self evaluateJavaScript:str completionHandler:^(id _Nullable top, NSError * _Nullable error) {
        if (block) {
            block([top floatValue]);
        }
    }];
}

- (void)getOffsetLeftWithPoint:(CGPoint)point callBlock:(WKWebViewElementCallBack)block {
    NSString * getLeftStr =[NSString stringWithFormat:
                            @"var script = document.createElement('script');"
                            "script.type = 'text/javascript';"
                            "script.text = \"function getAbsLeft(e){"
                            "var offsetLeft = e.offsetLeft;"
                            "if(e.offsetParent!=null){"
                            "offsetLeft += getAbsLeft(e.offsetParent);"
                            "}"
                            "return offsetLeft;"
                            "};"
                            "function getLeft(){"
                            "var ele = document.elementFromPoint(%f,%f);"
                            "return getAbsLeft(ele);"
                            "}\";"
                            "document.getElementsByTagName('head')[0].appendChild(script);", point.x, point.y];
    
    [self evaluateJavaScript:getLeftStr completionHandler:nil];
    
    NSString *str = @"getLeft()";
    [self evaluateJavaScript:str completionHandler:^(id _Nullable left, NSError * _Nullable error) {
        if (block) {
            block([left floatValue]);
        }
    }];
}

- (void)getElementWidthWithPoint:(CGPoint)point callBlock:(WKWebViewElementCallBack)block {
    NSString *jsString = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).offsetWidth", point.x, point.y];
    [self evaluateJavaScript:jsString completionHandler:^(id _Nullable width, NSError * _Nullable error) {
        if (block) {
            block([width floatValue]);
        }
    }];
}

- (void)getElementHeightWithPoint:(CGPoint)point callBlock:(WKWebViewElementCallBack)block {
    NSString *jsString = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).offsetHeight", point.x, point.y];
    [self evaluateJavaScript:jsString completionHandler:^(id _Nullable height, NSError * _Nullable error) {
        if (block) {
            block([height floatValue]);
        }
    }];
}

- (void)getWindowPageXOffsetCallBlock:(WKWebViewElementCallBack)block {
    NSString *jsString = @"window.pageXOffset";
    [self evaluateJavaScript:jsString completionHandler:^(id _Nullable pageXOffset, NSError * _Nullable error) {
        if (block) {
            block([pageXOffset floatValue]);
        }
    }];
}

- (void)getWindowPageYOffsetCallBlock:(WKWebViewElementCallBack)block {
    NSString *jsString = @"window.pageYOffset";
    [self evaluateJavaScript:jsString completionHandler:^(id _Nullable pageYOffset, NSError * _Nullable error) {
        if (block) {
            block([pageYOffset floatValue]);
        }
    }];
}


@end
