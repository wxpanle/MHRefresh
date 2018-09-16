//
//  NSFileHandle+UPReadLine.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileHandle (UPReadLine)

- (NSData *)readLineWithDelimiter:(NSString *)theDelimier;

@end
