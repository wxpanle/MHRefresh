//
//  QYTThirteenKnowdege.h
//  MHRefresh
//
//  Created by panle on 2018/6/4.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYTThirteenKnowdege : NSObject

@end


/**
 13  高效绘图
 */


/**
 13.0.0  软件绘图
 
 绘图通常在Core Animation 的上下文中指代软件绘图（即不由GPU协助的绘图）   iOS 中 CoreAnimation 通常是由Core Graphice 框架来完成 但是在一些必要的情况下  相比 Core Animation 和  OpneGL . Core Graphice 要慢了不少
 
 软件绘图不仅效率低，还会消耗可观的内存。CALayer 只需要一些与自己相关的内存，只有它的寄宿图会消耗一定的内存空间即使直接赋给contents属性一张图片，也不需要增加额外的照片存储大小。如果相同的一张图片被多个图层作为contents属性，那么他们将会共用同一块内存，而不是复制内存块。
 
 但是你一旦实现了 CALayerDelegate 协议中的 -drawLayer:inContext  或者UIView中的 -drawRect：（方法）  图层就会创建一个绘制上下文，这个上下文需要的大小的内存可以从这个算是得出   图层 * 款 * 高  * 4字节， 宽高的单位均为像素，对于一个在 Retina iPad上的全屏图来说，这个内存量就是2058 * 1526 * 4 字节，相当于12MB  图层每次重绘的时候都需要重新抹掉内存  然后重新分配
 
 软件绘图的代价昂贵，除非绝对必要，你应该避免重绘你的视图，提高绘制性能的秘诀在于尽量避免去绘制
 
 
 13.0.1 矢量图形
 
 我们用Core Graphics 来绘图的一个通常的原因就是只是用图片或是图层效果不能轻易的绘制出矢量图形。  矢量图形包含以下
   1. 任意多边形
   2. 斜线或者曲线
   3. 文本
   4. 渐变
 
 13.0.2 脏矩形
 
 有时候用 CAShapeLayer 或者其它矢量图形图层替代Core Graphice 并不是那么切实可行。比如我们的绘图应用  我们用线条完美的完成了矢量绘制，但是摄像一下如果我们能进一步提高应用的性能，让它就像一个黑板一样工作，然后用粉笔来绘制线条。模拟粉笔最简单的方法就是用一个线刷图片然后将它粘贴到用户手指触碰的地方，但是这个方法用CAShapeLayer没办法实现
 
 为了减少不必要的绘制，iOS设备会把屏幕区分为需要重绘的区域和不需要重绘的区域，那些需要重绘的部分被称作脏区域。在实际应用中，鉴于非矩形区域边界裁剪和混合的复杂性，通常会区分出包含指定视图的矩形位置  而这个位置就是脏图形。
 
 当一个视图被改动过了  就需要被重绘  但是在很多情况下，只是这个视图的一部分被改变了   所以重绘整个寄宿图太浪费了   但是core Animation  通常不了解你的自定义绘图代码  它也不能自己计算出脏区域的位置
 
 当你检测到指定视图或图层的指定部分需要被重绘，你直接调用  setneedsDisplayInRect 来标记它， 然后将影响到的矩形作为参数传入，这样就会在一次视图刷新的调用视图的  -drawRect: （或图层代理的  -drawLayer: inContext: 方法）。
 
 传入 -drawLayer:inContext: 的 CGContext  参数会自动裁切以适应对应的矩形。为了确定矩形的尺寸大小  你可以用CGContextGetClipBoundingBox（）方法来从上下文获得大小   调用  -drawRect()  会更简单  因为CGRect  会作为参数直接传入
 
 13.0.4 异步绘制
 
 UIKit的单线程天性意味着寄宿图通畅要在主线程上更新，这意味着绘制会打断用户交互，甚至让整个app看起来处于无响应状态。我们对此无能为力，但是如果能避免用户等待绘制完成就好多了
 
 我们可以在另一个线程上绘制内容，然后将由此线程绘制的图片直接设置为图层的内容
 
 
 13.0.5 CATiledLayer
 
 有一个有趣的特性  在多个线层中为每个小块同时调用 drawLayer:inContext 方法。  这就避免了阻塞用户交互而且能够利用多核心芯片来更快的绘制  只有一个小块的CATiledLay
 
 
 13.0.6 drawsAsynchronously
 
 iOS 6 中  苹果为CALayer引入了这个令人好奇的属性，drawsAsynchronously 属性对传入  drawLayer:incontext的CGContext进行改动  允许CGContext延缓绘制命令的执行以至于不阻塞用户交互
 
 它自己的-drawLayer:inContext:方法只会在主线程调用，但是CGContext并不等待每个绘制命令的结束。相反地，它会将命令加入队列，当方法返回时，在后台线程逐个执行真正的绘制。
 */
