//
//  QYPreviewImageHeader.h
//  MHRefresh
//
//  Created by developer on 2017/9/15.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYPreviewImageHeader_h
#define QYPreviewImageHeader_h

#define QY_SCREEN_INITIAL_W [UIScreen mainScreen].bounds.size.width
#define QY_SCREEN_INITIAL_H [UIScreen mainScreen].bounds.size.height

#define QY_SCREEN_W (QY_SCREEN_INITIAL_W < QY_SCREEN_INITIAL_H ? QY_SCREEN_INITIAL_W : QY_SCREEN_INITIAL_H)
#define QY_SCREEN_H (QY_SCREEN_INITIAL_W > QY_SCREEN_INITIAL_H ? QY_SCREEN_INITIAL_W : QY_SCREEN_INITIAL_H)
#define QY_SCREEN_SIZE CGSizeMake(QY_SCREEN_W, QY_SCREEN_H)

static inline CGFLOAT_TYPE CGFloat_fabs(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return fabs(cgfloat);
#else
    return fabsf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_acosf(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return acos(cgfloat);
#else
    return acosf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_asinf(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return asin(cgfloat);
#else
    return asinf(cgfloat);
#endif
}




#endif /* QYPreviewImageHeader_h */
