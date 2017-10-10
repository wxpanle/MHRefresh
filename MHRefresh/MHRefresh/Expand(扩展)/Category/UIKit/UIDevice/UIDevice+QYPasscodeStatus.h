//
//  UIDevice+QYPasscodeStatus.h
//  MHRefresh
//
//  Created by developer on 2017/10/9.
//  Copyright © 2017年 developer. All rights reserved.
//

///--------------------------------------------------------------
/// @name https://github.com/liamnichols/UIDevice-PasscodeStatus
///--------------------------------------------------------------

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYPasscodeStatus) {
    
    QYPasscodeStatusUnknow,
    QYPasscodeStatusEnabled,
    QYPasscodeStatusDisabled
};

@interface UIDevice (QYPasscodeStatus)

- (BOOL)passcodeStatusSupported;

- (QYPasscodeStatus)passcodeStatus;

@end
