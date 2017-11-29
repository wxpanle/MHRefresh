//
//  QYStaticInline.h
//  MHRefresh
//
//  Created by developer on 2017/10/11.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef QYStaticInline_h
#define QYStaticInline_h

static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);   //如果参数是小数，则求最小的整数但不小于本身.  3.14 -> 4.0
#else
    return ceilf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_floor(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return floor(cgfloat);  //如果参数是小数，则求最大的整数但不大于本身.  3.14 -> 3.0
#else
    return floorf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_sqrt(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return sqrt(cgfloat);
#else
    return sqrtf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_round(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return round(cgfloat);
#else
    return roundf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_fab(CGFLOAT_TYPE cgFloat) {
#if CGFLOAT_IS_DOUBLE
    return fabs(cgFloat);
#else
    return fabsf(cgFloat);
#endif
}


#endif /* QYStaticInline_h */
