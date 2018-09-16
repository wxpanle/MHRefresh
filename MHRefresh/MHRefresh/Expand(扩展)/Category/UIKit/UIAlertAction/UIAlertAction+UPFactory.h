//
//  UIAlertAction+UPFactory.h
//  Up
//
//  Created by panle on 2018/4/18.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UPAlertActionTitleType) {
    UPAlertActionTitleTypeCancel,   //取消
    UPAlertActionTitleTypeOk,       //是
    UPAlertActionTitleTypeNo,       //否
    UPAlertActionTitleTypeDone,     //确定
    UPAlertActionTitleTypeSet,      //设置
    UPAlertActionTitleTypeSave,     //保存
    UPAlertActionTitleTypeQuit      //退出
};

@interface UIAlertAction (UPFactory)

+ (instancetype)actionWithTitleType:(UPAlertActionTitleType)titleType handle:(void (^) (UIAlertAction * action))handle;

+ (instancetype)actionWithTitleType:(UPAlertActionTitleType)titleType style:(UIAlertActionStyle)style handle:(void (^) (UIAlertAction * action))handle;

+ (NSString *)titleWithType:(UPAlertActionTitleType)type;

@end
