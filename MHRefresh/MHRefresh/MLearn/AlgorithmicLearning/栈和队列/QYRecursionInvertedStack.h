//
//  QYRecursionInvertedStack.h
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYProtocolHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYRecursionInvertedStack : NSObject <QYStackDelegate>

- (void)qy_startRecursionInverted;

@end

NS_ASSUME_NONNULL_END
