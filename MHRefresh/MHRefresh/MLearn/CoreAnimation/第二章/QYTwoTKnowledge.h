//
//  QYTwoTKnowledge.h
//  MHRefresh
//
//  Created by panle on 2018/4/17.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYTwoTKnowledge : NSObject

@end


/**
 第二章   寄宿图（图层中包含的图）
 
 1.contents属性
    类型id 如果给contents赋值的不是CGImage,将得到空白图层
    layer.contents = (__bridge id)image.CGImage
 
 2.contentGravity  拉伸图片以适应图层
    view.contentMode = UIViewContentModeScaleAspectfit;
    CALayer的contentMode对应的属性叫做contentGravity
    kCAGravity  Center Top Bottom Left Right TopLeft TopRight BottomLeft BottomRight Resize ResizeAspect ResizeAspectFill  为了决定内容在图层的边界中怎么对齐。
 
    self.layer.contentsGravity = kkCAGravityResizeAspect  == view.contentMode = UIViewContentModeScaleAspectfit;
 
 3.contentScale
    属性定义了寄宿图的像素尺寸和视图大小的比例，default = 1.0
    该属性其实属于支持高分辨率屏幕机制的一部分，它用来判断绘制图层的时候应该为寄宿图创建的空间大小，和需要显示的图片的拉伸度（没有设置contentGravity的前提下）
    如果contentsScale设置为1.0的话。将会以每个点1个像素绘制图片，如果设置为2.0，将会以每个点2个像素绘制图片。
    layer.contentScale = [UIScreen mainScreen].scale
 
 4.maskToBounds
    默认情况下，UIView仍会允许绘制超过边界的内容或是子视图，CALayer也是这样。
    UIView有一个clipsToBounds的属性可以用来决定是否显示超出边界的内容 == CALayer.maskToBounds
 
 5.contentsRect
    该属性允许我们在图层边框里显示寄宿图的一个子域，和bounds和frame不同，不是按点计算的，它使用了单位坐标，单位坐标指定在0-1之间，是一个相对值（像素和点就是绝对值），所以它们是相对于寄宿图的尺寸的。
    点-坐标体系，点就是虚拟的像素，也被称之为逻辑像素，在标准设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素，iOS使用点作为屏幕的坐标测算体系就是为了在Retina设备和普通设备上能有一直的视觉效果
    像素-物理像素坐标并不会用来屏幕布局，但是仍然与图片有相对关系，UIImage是一个屏幕分辨率解决方案，所以指定点来度量大小，所以一些底层的图片表示和CGImage就会使用像素，所以你要清楚在Retina设备和普通设备上，它们表现出来了不同的大小。
    单位-对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式，当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用的多，CoreAnimation中也用到了。
    默认的contentsRect {0,0,1,1}.这意味着整个寄宿图都是可见的。如果我们指定一个小一点的矩形，图片就会被裁减
 
 6.contentsCenter
    该属性其实是一个CGRect，它定义了一个固定的边框和一个在图层上可以拉伸的区域，改变contentsCenter的值不会影响寄宿图的显示。
    default = {0, 0, 1, 1}
 
 7.custom drawing
    -drawRect:   -   core Graphics
    如果UIView检测到该方法被调用，就会为视图分配一个寄宿图，像素尺寸等于视图大小 * contentScale的值
 
 8.总结
    拼合技术
 */
