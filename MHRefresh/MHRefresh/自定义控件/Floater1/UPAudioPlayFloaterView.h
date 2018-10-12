//
//  UPAudioPlayFloaterView.h
//  Up
//
//  Created by panle on 2018/4/26.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPAPFloaterViewState) {
    UPAPFloaterViewStateUnknow,
    UPAPFloaterViewStatePlaying,
    UPAPFloaterViewStatePause
};

typedef NS_ENUM(NSInteger, UPAPFloaterViewPosition) {
    UPAPFloaterViewPositionEdge,  //处于边沿
    UPAPFloaterViewPositionShow,  //处于屏幕显示
    UPAPFloaterViewPositionHidden    //隐藏状态
};

@class UPAudioPlayFloaterView;

@protocol UPAudioPlayFloaterViewDelegate <NSObject>

- (void)up_audioPlayFloaterViewOpenEvent:(UPAudioPlayFloaterView *)floaterView;

- (void)up_audioPlayFloaterViewEdgeEvent:(UPAudioPlayFloaterView *)floaterView;

- (void)up_audioPlayFloaterViewCloseEvent:(UPAudioPlayFloaterView *)floaterView;

- (void)up_audioPlayFloaterViewListEvent:(UPAudioPlayFloaterView *)floaterView;

- (void)up_audioPlayFloaterViewPlayControlEvent:(UPAudioPlayFloaterView *)floaterView;

@end

@interface UPAudioPlayFloaterView : UIView

/** 控制刷新数据即可 */
@property (nonatomic, assign, readonly) UPAPFloaterViewState state;
/** 位置 */
@property (nonatomic, assign, readonly) UPAPFloaterViewPosition position;

@property (nonatomic, weak) id <UPAudioPlayFloaterViewDelegate> delegate;

+ (instancetype)audioPlayFloaterView;

- (void)up_updateDataWithState:(UPAPFloaterViewState)state imageName:(NSString *)imageName;

- (void)up_updateToPosition:(UPAPFloaterViewPosition)position;

@end
