//
//  QYStack.h
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYStack : NSObject

- (void)qy_push:(NSNumber *)obj;
- (nullable NSNumber *)qy_pop;
- (BOOL)qy_isEmpty;
- (nullable NSNumber *)qy_top;

- (void)qy_printf;

@end

NS_ASSUME_NONNULL_END
