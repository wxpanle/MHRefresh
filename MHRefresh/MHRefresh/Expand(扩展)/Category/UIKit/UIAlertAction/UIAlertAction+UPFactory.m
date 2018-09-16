//
//  UIAlertAction+UPFactory.m
//  Up
//
//  Created by panle on 2018/4/18.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIAlertAction+UPFactory.h"

@implementation UIAlertAction (UPFactory)

+ (instancetype)actionWithTitleType:(UPAlertActionTitleType)titleType handle:(void (^) (UIAlertAction * action))handle {
    
    return [self actionWithTitle:[self p_titleWithType:titleType] style:[self p_alertActionStyleWith:titleType] handler:handle];
}

+ (instancetype)actionWithTitleType:(UPAlertActionTitleType)titleType style:(UIAlertActionStyle)style handle:(void (^) (UIAlertAction * action))handle {
    return [UIAlertAction actionWithTitle:[self p_titleWithType:titleType] style:style handler:handle];
}

+ (NSString *)titleWithType:(UPAlertActionTitleType)type {
    return [self p_titleWithType:type];
}

+ (NSString *)p_titleWithType:(UPAlertActionTitleType)type {

    NSString *string = nil;
    switch (type) {
        case UPAlertActionTitleTypeCancel:
            string = LocalizedString(@"alert.actionTitle.cancel");
            break;
            
        case UPAlertActionTitleTypeNo:
            string = LocalizedString(@"alert.general.actionTitle.no");
            break;
            
        case UPAlertActionTitleTypeOk:
            string = LocalizedString(@"alert.general.actionTitle.ok");
            break;
            
        case UPAlertActionTitleTypeSet:
            string = LocalizedString(@"alert.actionTitle.set");
            break;
            
        case UPAlertActionTitleTypeDone:
            string = LocalizedString(@"alert.actionTitle.confirm");
            break;
            
        case UPAlertActionTitleTypeSave:
            string = LocalizedString(@"alert.actionTitel.save");
            break;
            
        case UPAlertActionTitleTypeQuit:
            string = LocalizedString(@"alert.actionTitle.quit");
            break;
    }
    
    return string;
}

+ (UIAlertActionStyle)p_alertActionStyleWith:(UPAlertActionTitleType)type {
    switch (type) {
        case UPAlertActionTitleTypeCancel:
            return UIAlertActionStyleCancel;
            break;
            
        default:
            return UIAlertActionStyleDefault;
            break;
    }
}

@end
