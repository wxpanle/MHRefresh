//
//  UITableViewHeaderFooterView+UPIdentifier.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UITableViewHeaderFooterView+UPIdentifier.h"

@implementation UITableViewHeaderFooterView (UPIdentifier)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
