//
//  UITableViewCell+QYIdentifier.m
//  MHRefresh
//
//  Created by developer on 2017/9/18.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UITableViewCell+QYIdentifier.h"

@implementation UITableViewCell (QYIdentifier)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
