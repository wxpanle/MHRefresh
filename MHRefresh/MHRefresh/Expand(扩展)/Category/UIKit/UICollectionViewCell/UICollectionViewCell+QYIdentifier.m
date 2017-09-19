//
//  UICollectionViewCell+QYIdentifier.m
//  MHRefresh
//
//  Created by developer on 2017/9/18.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UICollectionViewCell+QYIdentifier.h"

@implementation UICollectionViewCell (QYIdentifier)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
