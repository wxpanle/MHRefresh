//
//  CakeSortModel.h
//  test
//
//  Created by developer on 2017/10/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CakeSortModel : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCakeArray:(NSArray *)cakeArray;

- (void)sort;

@end
