//
//  QYProtocolHeader.h
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#ifndef QYProtocolHeader_h
#define QYProtocolHeader_h

@protocol QYStackDelegate <NSObject>

- (void)qy_push:(id)obj;
- (nullable id)qy_pop;
- (nullable id)qy_top;
- (BOOL)qy_isEmpty;
- (void)qy_printf;

@end


#endif /* QYProtocolHeader_h */
