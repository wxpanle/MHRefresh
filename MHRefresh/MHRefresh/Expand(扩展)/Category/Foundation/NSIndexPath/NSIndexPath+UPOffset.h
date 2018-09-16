//
//  NSIndexPath+UPOffset.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (UPOffset)

- (NSIndexPath *)previousRow;

- (NSIndexPath *)nextRow;

- (NSIndexPath *)previousItem;

- (NSIndexPath *)nextItem;

- (NSIndexPath *)nextSection;

- (NSIndexPath *)previousSection;

@end
