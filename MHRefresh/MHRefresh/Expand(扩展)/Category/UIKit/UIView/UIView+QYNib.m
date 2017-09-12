//
//  UIView+QYNib.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIView+QYNib.h"

@implementation UIView (QYNib)

+ (UINib *)loadNib {
    return [self loadNibName:NSStringFromClass([self class])];
}

+ (UINib *)loadNibName:(NSString *)name {
    return [self loadNibName:name bundle:[NSBundle mainBundle]];
}

+ (UINib *)loadNibName:(NSString *)name bundle:(NSBundle *)bundle {
    return [UINib nibWithNibName:name bundle:bundle];
}

+ (instancetype)loadInstanceFromNib {
    return [self loadInstanceFromNibWithName:NSStringFromClass([self class])];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)name {
    return [self loadInstanceFromNibWithName:name owner:nil];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)name owner:(id)owner {
    return [self loadInstanceFromNibWithName:name owner:owner bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)name owner:(id)owner bundle:(NSBundle *)bundle {
    
    UIView *result = nil;
    
    NSArray *elements = [bundle loadNibNamed:name owner:owner options:nil];
    
    for (id object in elements) {
        if ([object isKindOfClass:[self class]]) {
            result = object;
            break;
        }
    }
    return result;
}

@end
