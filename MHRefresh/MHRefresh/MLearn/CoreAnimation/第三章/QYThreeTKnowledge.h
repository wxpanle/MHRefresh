//
//  QYThreeTKnowledge.h
//  MHRefresh
//
//  Created by panle on 2018/4/19.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYThreeTKnowledge : NSObject

@end


/** 第三章
 1.布局
    UIView布局属性frame，bounds，center,  对应于 frame，bounds，position
    frame代表了图层的外部坐标(也就是在父图层上占据的控件)，bounds是内部坐标，（{0，0}通常是内部的左上角）， center和position都代表了相对于父图层anchorPoint所在的位置。anchorPoint的属性代表了土城的中心点
    对于图层来说，frame并不是一个非常清晰的属性，它其实是一个虚拟属性，是根据bounds，position，transform计算的来的，当一种任意一个值发生改变时，frame都会变化。
    当图层做变换的时候，比如旋转或者缩放，frame实际上代表了覆盖在图层旋转之后的整个轴对齐的矩形区域，也就是说fram的宽高可能和bounds不再一致。
 
 2.锚点
    视图的center和position属性都指定了anchorPoint相对于父图层的位置，可以认为anchorPoint是用来移动图层的把柄。
    默认来说，anchorPoint位于图层的终点，所以图层将会以这个点为中心防止
    与contentsRct和contentsCenter属性类似，anchorPoint用单位坐标来描述，也就是图层的相对坐标，左上角{00}，右下角{11}，默认坐标{0.5，0.5}
 
 3.坐标系
    和视图一样，图层在图层树当中也是相对于父图层按层级关系防止，一个图层的position依赖于它覆土层的bounds，如果图层发生了移动，它的所有子视图也会跟着移动。
    - (CGPoint)convertPoint:(CGPoint)point fromLayer:(CAlayer *)layer;
    - (CGPoint)convertPoint:(CGPoint)point toLayer:(CAlayer *)layer;
    - (CGRect)convertRect:(CGRect)point fromLayer:(CAlayer *)layer;
    - (CGRect)convertRectt:(CGRect)point fromLayer:(CAlayer *)layer;
    这些方法可以把定义在一个图层坐标系下的点或者矩形转换成另一个图层坐标系下的点或者矩形
 
 4.翻转的集合结构
    默认来说，一个图层的position位于父图层的左上角，coreAnimation可以通过 geomwtryFlipped属性来适配这两种情况，它决定了一个图层的坐标是否相对于父图层垂直翻转，是一个BOOL类型，iOS上设置为YES将意味着图层会被垂直翻转。
 
 5.Z坐标
    和UIView严格的二维坐标系不同，CALayer存在于一个三维空间中，zPosition,anchorPointX，二者都是在Z轴上描述图层位置的浮点类型
    图层是一个完全扁平的对象
    zPosition设计到图层的3D变化，以及改变图层的显示顺序
    通常，图层根据子图层的sublayers出现的顺序来绘制，但是通过增加图层的zPosition，就可以把图层向相机方向前置。
    所谓的相机 实际上是相对于用户是视角，这里和iPhone背后出现的内置相机没任何关系
 
 6.Hit Testing
    图层树表明最好使用图层的相关视图，而不是创建独立的图层关系，其中一个原因就是压迫处理额外复杂的触摸事件。
    CALayer 并不关心任何响应事件，所以不能直接处理触摸事件或者手势，但是它有一系列的方法帮你处理事件 - containsPoint: 和 -hitTest:
    - containsPoint: 接受一个在本土层坐标系下的point，如果这个点再图层的frame的范围内就返回YES
    -hitTest:同样接受一个point，而不是BOOL，它返回图层本身，或者包含这个坐标点的叶子节点图层，或者包含这个坐标点的叶子节点图层，这意味着不再需要判断测试点
    当调用图层的hitTest方法时，测算的顺序严格依赖于图层树当中的图层顺序，zPosition可以改变图层的显示顺序，但不能改变时间传递的顺序
 
 7.自动布局
    - ()layoutSubLayerOfLayer   当图层的bounds发生改变，或者图层的 setNeedsLayout方法被调用时，这个函数就会被执行，这使得你可以手动调整子视图的大小，但不能自适应屏幕旋转。
    这也表明最好使用视图而不是单独的图层来构建应用程序的另一个原因。
 
 8.总结
    本章涉及了CALayer的集合结构，包括它的frame，position，bounds，三维空间内的图层的概念，以及如何在独立的图层内响应事件。
 */
