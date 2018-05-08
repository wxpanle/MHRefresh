//
//  QYFourTKnowledge.h
//  MHRefresh
//
//  Created by panle on 2018/4/19.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYFourTKnowledge : NSObject

@end

/** 第四章
 1.视觉效果
    图层不仅仅可以是图片或者是颜色的容器，还有一些列内建的特性使得创造美丽优雅的令人深刻的界面元素成为可能
 
 2.圆角
    圆角矩形是iOS的一个标志性审美。
    CALayer cornerRadius 的属性控制着圆角的曲率。它是一个浮点数，默认为0（直角） 默认情况下，只影响背景色而不影响背景图片或是子图层，不过  如果把masksToBounds 设置为YES的话，图层里面的所有东西都会被截取
 
 3.图层边框
    borderWidth borderColor 二者共同定义了图层边的绘制样式，这条线沿着图层的bounds绘制，同时也包含图层的角。
    borderWidth 是以点为单位的定义边框粗细的浮点数，默认为0.
    borderColor 定义了边框的颜色，默认为黑色
    边框是绘制在图层边界里面的，而且在所有字内容之前，也在子图层之前
 
 4.阴影
    阴影往往可以达到图层深度按时的效果，也能够用来强调正在显示的图层和优先级
    shadowOpacity 属性一个大于默认值0的值，阴影就可以显示在任意图层之下，shadowOpacity是一个必须在0-1之间的浮点数，若要改变阴影的表现，通过  shadowColor shadowOffset shadowRadius
    shadowColor 控制阴影的颜色，默认黑色
    shadowOffset 属性控制着阴影的方向和距离，它是一个CGSize的值，宽度控制阴影横向的位移，高度控制着纵向的位移（0， -3）
    shadowRadius 控制阴影的模糊度，当它的值为0的时候，阴影就和视图一样有一个非常不确定的斌接线，非0值更好
 
 5.阴影裁剪
    和图层边框不同，图层阴影继承自内容的外形，而不是根据边界和角半径来确定，如果开启了masksBounds属性，所有图层中突出来的内容就会被裁剪掉。如果你想沿着内容裁剪，可以做一个只画阴影的空的外图层，和一个裁剪内容的内图层
 
 6.shadowPath
    可以通过制定shadowPath提高性能， 阴影的形状
 
 7.图层蒙版
    mask  属性  类似于一个自图层，相对于父视图布局  但不是一个普通的子图层，mask图层定义了父图层的部分可见区域。
 
 8.拉伸过滤
    minificationFilter 和  magnificationFilter 属性， 以1：1比例正确的显示图片
    当图片需要显示不同大小的时候，有一种叫做拉伸过滤的算法就起到了作用，它作用于原图的像素上并根据需要生成新的像素显示在屏幕上
    kCAFilterLinear  kCAFilterNearest  kCAFilterTrilinear
    默认的过滤器都是 Linear  这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好，双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现的不错的拉伸，但是当方法背书比较大的时候图片就模糊不清了。
    Trilinear 三性滤波算法存储了多个大小情况下的图片，并三维取样，同时结合大图和小兔的存储进而得到最后的结果
    Neareat 是一种比较五段的方法，这个算法就是取样最近的单像素点而不管其它的颜色。这样做非常快，也不会使图片模糊，但是，会压缩图片变得更糟，图片放大后也显得不清晰
 
 9.组透明
    UIView的alpha的属性来确定视图的透明度，CALayer有一个等同的属性叫做opacity，这两个属性都是影响子层级的。也就是说，如果你给一个图层设置了opacity，那么子图层也将受到影响。
    CALayer的一个叫做shouldRasterize属性来实现组透明的效果。
 */
