//
//  MWebViewProgress.h
//  Memory
//
//  Created by developer on 17/2/15.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MWebViewProgress;


@protocol MWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(MWebViewProgress *)webViewProgress updateProgress:(CGFloat)progress;

@end

@interface MWebViewProgress : NSObject <UIWebViewDelegate>

@property (nonatomic, weak) id <MWebViewProgressDelegate> webViewProgressDelegate;

@property (nonatomic, weak) id <UIWebViewDelegate> webViewProxyDelegate;

@end
