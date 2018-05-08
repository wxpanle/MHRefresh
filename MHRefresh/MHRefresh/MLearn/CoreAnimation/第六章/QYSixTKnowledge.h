//
//  QYSixTKnowledge.h
//  MHRefresh
//
//  Created by panle on 2018/5/2.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYSixTKnowledge : NSObject

@end


/**
 第六章 - 专用图层
 
 1.CAShapeLayer
    通过矢量图形而不是bitmap来绘制的图层子类，
    优点：快速渲染，CAShapeLayer使用了硬件加速，绘制同一图形会比用CoreGraphics块很多  高效实用内存，一个CAShapeLayer不需要像普通的CALayer一样创建一个急速图形，所以无论有多大，都不会占用太多的内存  不会被图层边界剪裁掉，一个CAShapeLayer可以在边界之外绘制   不会出现像素化
 
 1.1.创建一个CGPath
    CAlayer可以绘制所有通过CGPath来表示的形状，这个形状不一定要闭合，图层路径页不一定要不可破，事实上你可以在一个图层上绘制好几个不同的形状，你可以控制一些属性比如和lineWidth  lineCap  lineJoin,  但是在图层层面你只有一次机会设置这些属性
 
 1.2.圆角
    UIBezierPath 创建视图的圆角
 
 */

/**
 2. CATextLayer
 
 2.1 用户界面无法从一个单独的图片里面构建，一个设计良好的图标能够很好的表现一个按钮或空间的意图，不过你迟早都需要一个不错的老式风格的文本标签
     如果你想在一个图层里面显示文字，完全可以借助图层代理直接将字符串使用CoreGraphics写入图层的内容，这就是UILabel的精髓，如果越过寄宿图的视图，直接在视图生操作那其实相当繁琐。你要为每一个显示文字的图层创建一个能像图层代理一样工作的类，还要逻辑上判断哪个图层需要显示哪个字符串。
 
    CATextLayer比UILabel渲染快速很多
 
 2.2 富文本
    CATextLayer支持富文本属性
 
 2.3 行距和字距
    与UIlabel不同的是CATextLayer绘制的文本行距和字距也不是不尽相同的
 
 2.4 UILabel的替代品
    我们可以选择继承UILabel，然后添加一个自图层CATextLayer并重写显示文本的方法，但是仍然会有由UILabel的 -drawRect方法创建的空寄宿图，而且由于CALayer不支持自动缩放和自动布局
 
    +layerClass可以创建基于不同图层的视图是一个简单可复用的方法
 */


/**
 3. CATransformLayer
 
 3.1 CATransformLayer不同于普通的layer，因为它不能显示自己的内容，只有当存在了一个能作用域子图层的变换它才真正存在，因为它不能显示它自己的内容，只有当存在了一个能作用域子图层的变换它才真正存在，它并不平面化它的自图层
 */


/**
 4. CAGradientLayer
 
 4.1 用来生成两种或更多颜色平滑渐变  绘制使用了硬件加速
 
 4.2 基础渐变
    startPoint 和  endPoint属性，它们决定了渐变的方向 这两个参数是以单位坐标系进行的定义，左上角{0 0}  右下角{1 1}
 
 4.3 多重渐变
    colors可以包含很多颜色 这些颜色在控件上被均匀的渲染，但是我们可以使用 locations 属性来调整空间，是一个浮点数值的数组，这些浮点数定义了colors属性中每个颜色的位置，0.0代表渐变开始 1.0代表渐变结束
 */

/**
 5. CAReplicatorLayer
 
 5.1 目的是为了高效生成许多相似的图层，它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变化
 
 5.2 重复图层
    instanceCount 指定图层需要重复多少次   instanceTransform
 
 5.3 反射
    应用一个负比例变换于一个复制图层
 */

/**
 6. CAScrollLayer
 
 6.1 未转换的图层来说，bounds和frame是一样的，frame属性时由bounds属性自动计算得出的
 */


/**
 7. CATiledLayer
 
 7.1 有时候你可能需要绘制一张很大的图片，常见的一个例子是一个高像素的照片或者是地球表面的详细地图  能高效绘制在iOS上的图片也有一个大小限制，所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，最大为2048 * 2048 或 4096 * 4096。 Core animation 强制使用CPU处理图片而不是GPU CATiledLayer提供了一个解决方案，将大图分解成小图  按需单独载入各个小图
 
 7.2 小片裁剪
 
 7.3 Retina小图
 
 */

/**
 8. CAEmitterLayer
 
 8.1 这是一个高性能的粒子引擎，被用来创建实时粒子动画
 
 8.2
 */


/**
 9. CAEAGLLayer
 
 9.1 当iOS要处理高性能的图形绘制，必要时使用OpenGL  openGL没有对象或是图层的继承概念，它只是简单的处理三角形，  提供了一个叫CLKView的UIView的子类，帮你处理大部分的设置和绘制工作，前提是各种各样的OpenGL绘图缓冲的底层可配置仍然需要你用CAEAGLLayer完成，它用来显示任意的OpenGL图形
 */

/**
 10. AVPlayerLayer
 
 */



