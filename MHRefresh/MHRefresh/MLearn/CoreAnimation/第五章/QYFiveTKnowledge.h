//
//  QYFiveTKnowledge.h
//  MHRefresh
//
//  Created by panle on 2018/4/20.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYFiveTKnowledge : NSObject
@end

/** 第五章
 1.变换
    图层旋转，摆放或者扭曲的CGAffineTransform,以及可以将扁平物体转化成三维空间对象的CAtransform3D
 
 2.仿射变化
    UIView 的transform属性旋转了钟的之臣，是一个CGAffineTransform类型，用于在二维空间做旋转，缩放和平移处理，CGAffineTransform是一个可以和二维空间向量做乘法的3*2矩阵
                [a  b  0]
    [x y 1]  *  [c  d  0]  = [x1 y1 1]
                [tx ty 1]
 
    CGPoint   CGAffineTransform   CGPoint
    用CGPoint的每一列和CGAffineTransform矩阵的每一行对应元素相乘再求和，就形成了一个新的CGPoint类型的结果，为了能让矩阵做乘法，左边矩阵的列数一定要和右边矩阵行数个数相同，所以要给矩阵填充一些标志值，使得既可以让矩阵做乘法，又不改变运算结果刚没并且没必要存储这些添加的值
    因此 通常会用3*3的矩阵来做二维变换
    当图层应用变换矩阵，图层矩形内的每一个点都被相应的变换，从而形成一个新的四边形的形状，仿射的意思就是无论变换矩阵用什么值，图层中平行的两条线在变换之后依然保持平行
 
 3.CGAffineTransform
    创建的3中方法
    CGAffineTransformMakeRotation(CGFloat angle)
    CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
    CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
    旋转和缩放变换都很好解释，分别旋转或者缩放一个变量的值。平移变换是指每个点都移动了向量指定的x或者y值，所以如果向量代表了一个点，那它就平移了这个点的距离
 
    CALayer 对应 UIView 的transform的属性叫做affineTransform
 
 4.混合变换
    当操纵一个变换的时候，初始生成一个什么都不做的变换很重要，也就是创建一个CGAffineTransform类型的空值，矩阵中称为单位矩阵
    CGAffineTransformIdentity
    如果两个混合变化已经存在的变换矩阵
    #define DEGREES_TO_RADIANS(x) ((x) / 180.0 * M_PI)
 
 5.3D变换
    zPosition属性可以让图层靠近或者原理相机（用户视觉），transform属性（CGTransform#D）可以让图层在3维空间做变换的4*4矩阵
                [m11 m21 m31 m41]
                [m12 m22 m32 m42]
    [x y z 1]   [m13 m23 m33 m43] = [x1 y1 z1 1]
                [m14 m24 m34 m44]
 
    X Y 轴比较熟悉，分别以向右和向下为正方向，z轴分别于这两个轴垂直，指向视角外为正方向
 
 6.透视投影
    CGTransform#D的透视效果通过一个矩阵中一个很简单的元素来控制  M34  用于按比例素平方XY的值来计算到底要离视角多远
    默认值为0，我们可以通过设置 -1.0/d来应用透视效果，d代表了想象中视觉相机和屏幕之间的距离，以像素为单位，
 
 7.灭点
    当在透视角度绘图的时候吗，远离相机视觉的物体会越变越远，当远离到一个极限距离，它们可能缩成了一个点，于是所有的物体最后都汇聚消失在同一个点
    现实中 灭点通常是屏幕的中心
    变换图层的anchorPoint，当图层发生变化时，这个带你永远位于图层变换之前anchorPoint的位置
 
 8.sublayerTransform
    如果有多个视图或者体层，每个都做3D变换，那就需要分别设置相同的m34值，并且确保在变换之前都在屏幕中央共享同一个position，
    该属性使你可以一次性对包含这些图层的容器做变换，于是所有的自图层都自动继承了这个变换方法
 
 9.背面
    旋转180度  完全背对相机视角
    图层是双面绘制的，反面显示的是正面一个镜像图片。
    CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制，这是一个BOOL类型，默认为YES,如果设置为NO,那么当图层正面从相机视角小时的时候，它将不会被绘制
 
 10.扁平化图层
    每个图层场景其实是扁平化的，当你从正面观察一个一个图层，看到的实际上是由自图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面
 
 11.固体对象
 
 12.光亮和阴影
 
 13.点击事件
 */
