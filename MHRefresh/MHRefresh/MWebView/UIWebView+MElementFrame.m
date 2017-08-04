//
//  UIWebView+MElementFrame.m
//  Memory
//
//  Created by developer on 17/5/8.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "UIWebView+MElementFrame.h"

@implementation UIWebView (MElementFrame)

- (CGRect)elementFrameWithPoint:(CGPoint)point {
    CGFloat pageXoffset = [self getWindowPageXOffset];
    CGFloat pageYoffet = [self getWindowPageYOffset];
    CGFloat elementOffsetLeft = [self getOffsetLeftWithPoint:point];
    CGFloat elemnrtOffsetTop = [self getOffsetTopWithPoint:point];
    CGFloat elementWidth = [self getElementWidthWithPoint:point];
    CGFloat elementHeight = [self getElementHeightWithPoint:point];
    NSLog(@"frame = %@", NSStringFromCGRect(CGRectMake(elementOffsetLeft - pageXoffset, elemnrtOffsetTop - pageYoffet, elementWidth, elementHeight)));
    return CGRectMake(elementOffsetLeft - pageXoffset, elemnrtOffsetTop - pageYoffet, elementWidth, elementHeight);
}

- (CGFloat)getOffsetTopWithPoint:(CGPoint)point {
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
    [self stringByEvaluatingJavaScriptFromString:getTopStr];
    NSString *jsString = [self stringByEvaluatingJavaScriptFromString:@"getTop()"];
    return [jsString floatValue];
}

- (CGFloat)getOffsetLeftWithPoint:(CGPoint)point {
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
    [self stringByEvaluatingJavaScriptFromString:getLeftStr];
    NSString *jsString = [self stringByEvaluatingJavaScriptFromString:@"getLeft()"];
    return [jsString floatValue];
}

- (CGFloat)getElementWidthWithPoint:(CGPoint)point {
    NSString *jsString = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).offsetWidth", point.x, point.y];
    return [[self stringByEvaluatingJavaScriptFromString:jsString] floatValue];
}

- (CGFloat)getElementHeightWithPoint:(CGPoint)point {
    NSString *jsString = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).offsetHeight", point.x, point.y];
    return [[self stringByEvaluatingJavaScriptFromString:jsString] floatValue];
}

- (CGFloat)getWindowPageXOffset{
    return [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] floatValue];
}

- (CGFloat)getWindowPageYOffset{
    return [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] floatValue];
}

@end
