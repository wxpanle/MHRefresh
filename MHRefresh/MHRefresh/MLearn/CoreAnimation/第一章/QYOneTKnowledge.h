//
//  QYOneTKnowledge.h
//  MHRefresh
//
//  Created by panle on 2018/4/16.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYOneTKnowledge : NSObject

@end

/*
 Core Animation 是一个复合引擎，它的职责是尽可能的组合屏幕上的不同的可视内容，这个内容是被分解成独立的图层，存储在一个叫做图层树的体系之中，于是这个树形成了UIKit以及在iOS应用程序当中你所能在屏幕上看见的一切的基础。
 */

/*
 第一章
 
 1. 图层与视图
    一个视图就是在屏幕上显示的一个举行块，它能够拦截类似于鼠标点击或者触摸手势等待用户的输入，视图在层级中可以互相嵌套。
    iOS中所有的视图都是从一个叫做UIView的基类派生而来。
 
 2.CALayer
    概念上和UIView类似，同样也是一些被层级关系树管理的矩形块，但layer不处理用户的交互
    响应链 - iOS通过视图层级关系来传递出no事件的机制
 
 3.平行的层级关系
    每一个UIView都有一个CALayer实例的图层属性，视图的职责就是创建并管理这个图层。
    UIView和CALayer是平行的层级关系，原因在于职责分离，避免重复代码。
    视图层级 -  图层数 - 呈现树 - 渲染树
 
 4.图层的能力
    CALayer是UIView的内部实现细节
    UIView未实现的功能
        1.阴影、圆角、带颜色的边框
        2.3D变换
        3.非矩形范围
        4.透明遮罩
        5.多级非线性动画
 
 5.使用图层
    好处：能使用所有CALayer底层特性的同时，也可以使用UIView的高级API如自动排版、布局、事件处理
    使用CALayer并不是UIView
        1.开发跨平台应用
        2.使用多种CALayer的子类，并且不想创建额外的UIView去封装它们
        3.优化性能
 
 6.总结
    如何在iOS中由UIView的层级关系形成的一种平行的CALayer的层级关系。
 */
