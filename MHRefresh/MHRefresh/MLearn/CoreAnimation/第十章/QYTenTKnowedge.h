//
//  QYTenTKnowedge.h
//  MHRefresh
//
//  Created by panle on 2018/5/9.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYTenTKnowedge : NSObject

@end

/**
 第十章  缓冲
 
 
 */

/**
 10.1 动画速度
 
 动画实际上就是一段时间内的变化  变化一定是随着某个特定的速率运行
 
 等式1 velocity = change / time
 
 这里的变化可以指的是一个物体移动的距离，时间指动画持续的时长，用这个动画可以更加形象的描述  比如position和bounds属性的动画，但实际上它应用于任意可以做动画的属性   比如color和opacity
 
 等式1 假定了速度在整个动画过程中都是恒定不变的  对于这种恒定的动画我们称之为线性步调  而且懂技术的角度而言这也是实现动画的最简单的方式，但也是完全不真实的一种效果
 
 现实生活中任何一个物体都会在运动中加速或者减速  一种方法是使用武力引擎对运动物体的摩擦和动量来建模，然而这回使得计算过于复杂  我们称这种类型的方程为缓冲函数  coreAnimation提供了一系列的标准函数供我们使用

 
 10.1.1 CAMediaTimingFunction
 
 CAAnimation timingFunction 属性   如果向改变隐式动画的计时函数
 
 kCAMediaTimingFunctionLinear
 kCAMediaTimingFunctionEaseIn
 kCAMediaTimingFunctionEaseOut
 kCAMediaTimingFunctionEaseInEaseOut
 kCAMediaTimingFunctionDefault
 
 kCAMediaTimingFunctionLinear选项创建了一个线性的计时函数，同样也是CAAnimation的timingFunction属性为空时候的默认函数。线性步调对于那些立即加速并且保持匀速到达终点的场景会有意义（例如射出枪膛的子弹），但是默认来说它看起来很奇怪，因为对大多数的动画来说确实很少用到。
 
 kCAMediaTimingFunctionEaseOut则恰恰相反，它以一个全速开始，然后慢慢减速停止。它有一个削弱的效果，应用的场景比如一扇门慢慢地关上，而不是砰地一声。
 
 kCAMediaTimingFunctionEaseInEaseOut创建了一个慢慢加速然后再慢慢减速的过程。这是现实世界大多数物体移动的方式，也是大多数动画来说最好的选择。如果只可以用一种缓冲函数的话，那就必须是它了。那么你会疑惑为什么这不是默认的选择，实际上当使用UIView的动画方法时，他的确是默认的，但当创建CAAnimation的时候，就需要手动设置它了。
 
 最后还有一个kCAMediaTimingFunctionDefault，它和kCAMediaTimingFunctionEaseInEaseOut很类似，但是加速和减速的过程都稍微有些慢。
 
 10.1.2 UIView的动画缓冲
 
 UIViewAnimationOptionCurveEaseInOut
 UIViewAnimationOptionCurveEaseIn
 UIViewAnimationOptionCurveEaseOut
 UIViewAnimationOptionCurveLinear
 
 
 10.1.3 缓冲和关键帧动画
 
 CAKeyframeAnimation  有一个 NSArray 类型的timingFunctions属性  我们可以用它来对每次动画的步骤指定不同的计时函数，但是指定函数的个数一定要等于keyFrames数组元素个数减一  因为它是描述每一帧之间动画速度的函数
 
 */

/**
 10.2  自定义缓冲函数
 
 除了+functionWithName之外  CAMediaTimingFunction 同样有另外一个构造函数  一个有四个浮点参数的 +functionWithControlPoints：：：：
 
 10.2.1 三次贝塞尔曲线
 
 CAmediaTimingFunction 函数的主要原则在于它把输入的时间转换成起点和终点之间成比例的改变
 
 线性缓冲函数就是一条过原点的直线
 
 这条曲线的斜率代表了速度，斜率的改变代表了加速度，原则上来说，任何加速的曲线都可以用这种图像来表示，CAMediaTimingFunction使用了一个叫做三次贝塞尔曲线的函数，它只可以产出指定缓冲函数的子集
 
 曲线由四个点定义，第一个和最后一个代表了曲线的起点和终点，剩下的两个点叫做控制点，因为他们控制了曲线的形状，贝塞尔曲线的控制点其实是位于曲线之外的点，也就是说曲线不一定要穿过他们，你可以把他们想象成吸引经过他们曲线的磁铁
 
 10.2.2 更加复杂的动画曲线
 
 10.2.3 基于关键帧的缓冲
 
 为了使用关键帧实现反弹动画，我们需要在缓冲曲线中对每一个显著的点创建一个关键帧（在这个情况下，关键点也就是每次反弹的峰值），然后应用缓冲函数把每段曲线连接起来。同时，我们也需要通过keyTimes来指定每个关键帧的时间偏移，由于每次反弹的时间都会减少，于是关键帧并不会均匀分布。

 10.2.4 流程自动化
 
 自动把任意属性动画分割成多个关键帧
 用一个数学函数表示弹性动画，使得可以对帧做偏移
 
 value = (endValue – startValue) × time + startValue;
 
 一旦我们可以用代码获取属性动画的起始值之间的任意插值，我们就可以把动画分割成许多独立的关键帧，然后产出一个线性的关键帧动画。
 
 
 */
