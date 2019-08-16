//
//  UPTestGradePercentageView.h
//  Up
//
//  Created by panle on 2019/8/13.
//  Copyright © 2019 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UPTestGradePercentageView : UIView

+ (instancetype)up_testGradePercentageView;

- (void)up_updateWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
