//
//  QYTwoStackQueue.h
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYTwoStackQueue : NSObject

- (void)qy_add:(id)obj;
- (nullable id)qy_poll;
- (void)qy_peek;

@end

NS_ASSUME_NONNULL_END
