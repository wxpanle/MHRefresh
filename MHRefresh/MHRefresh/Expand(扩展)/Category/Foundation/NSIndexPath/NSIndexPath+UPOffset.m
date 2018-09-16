//
//  NSIndexPath+UPOffset.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSIndexPath+UPOffset.h"

@implementation NSIndexPath (UPOffset)

- (NSIndexPath *)previousRow {
    
    return [NSIndexPath indexPathForRow:self.row - 1
                              inSection:self.section];
}

- (NSIndexPath *)nextRow {
    
    return [NSIndexPath indexPathForRow:self.row + 1
                              inSection:self.section];
}

- (NSIndexPath *)previousItem {
    
    return [NSIndexPath indexPathForItem:self.item - 1
                               inSection:self.section];
}


- (NSIndexPath *)nextItem {
    
    return [NSIndexPath indexPathForItem:self.item + 1
                               inSection:self.section];
}


- (NSIndexPath *)nextSection {
    
    return [NSIndexPath indexPathForRow:self.row
                              inSection:self.section + 1];
}

- (NSIndexPath *)previousSection {
    
    return [NSIndexPath indexPathForRow:self.row
                              inSection:self.section - 1];
}


@end
