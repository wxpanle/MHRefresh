//
//  QYTFiveteenKnowedge.h
//  MHRefresh
//
//  Created by panle on 2018/6/5.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYTFiveteenKnowedge : NSObject

@end

/**
 第十五章 图层性能
 */

/**
 15.1.0 隐式绘制
 
 寄宿图可以通过Core Graphics直接绘制，也可以直接载入一个图片文件并赋值给contents属性，或事先绘制一个屏幕之外的CGContext上下文。
 
 可以通过以下三种方式创建隐式的绘图 1.使用也行的的图层属性 2. 特定的图层  3.  特定的图层子类
 
 了解这个情况为什么发生何时发生是很重要的，它能够让你避免引入不必要的软件绘制行为
 
 15.1.1 文本
 
 CATextLayer  和 UILabel 都是直接将文本绘制在图层的寄宿图中。事实上这两种方式用了完全不同的渲染方式，在iOS6之前，UILabel 用 WebKit的HTML渲染引擎来绘制文本，而CATextLayer用的是Core Text. 后者渲染更迅速，所以在所有需要绘制大量文本的情况下都优先使用它
 
 尽可能的避免改变那些包含文本的视图的frame，因为这样做的话文本就需要重绘。例如，如果你想在图层的角落里显示一段静态的文本，但是这个图层经常改动，你就应该把文本放在一个子图层中。
 
 光栅化
 
 CALayer 的shouldRasterize属性  它可以解决重叠透明图层的混合失灵问题
 
 启用shouldRasterize 属性将会绘制到一个屏幕之外的图像。然后这个图像将会被缓存起来并绘制到实际图层的contents和子图层。如果有很多的子图层或者有复杂的效果应用。这样做就会比重绘所有事务的所有帧划得来。但是光栅化原始图像需要时间，而且还会消耗额外的内存。
 
 当使用得当 光栅化可以提供很大的优势  但是一定要避免作用在内容不断变动的图层上，否则它缓存方面的好处就会消失，而且会让性能变得更糟。
 
 用Instrument查看一下Color Hits Green和Misses Red项目，是否已光栅化图像被频繁地刷新（这样就说明图层并不是光栅化的好选择，或则你无意间触发了不必要的改变导致了重绘行为）。
 */

/**
 15.1.2 离屏渲染
 
 当图层属性的混合体被指定为在未预合成之前不能直接在屏幕中绘制时，屏幕外渲染就被唤起了。屏幕外的渲染并不意味着软件绘制，但是它意味着图层必须在被显示之前在一个屏幕外上下文中被渲染。 图层的以下属性将会触发屏幕外绘制
 
 圆角 （当合 maskToBounds一起使用时）
 图层蒙版
 阴影
 
 
 屏幕外渲染和我们启用光栅化时相似，除了它并没有像光栅化图层消耗那么大，自图层并没有被影响到。而且结果也没有被缓存，所以不会长期的内存占用。但是如果太多图层在屏幕外渲染依然会影响到性能
 
 
 15.1.3  CAShapeLayer
 
 cornerRadius  和  maskToBounds 独立作用的时候都不会有太大的性能问题，但是结合到一起的时候，就出发了屏幕外渲染。有时候你想显示圆角并沿着图层裁剪子图层的时候，你可能发现你不需要沿着圆角裁剪
 
 15.1.4 可伸缩图片
 
 另一个创建圆角矩形的方法就是用一个圆形内容图片并结合第二章『寄宿图』提到的contensCenter属性去创建一个可伸缩图片（见清单15.2）.理论上来说，这个应该比用CAShapeLayer要快，因为一个可拉伸图片只需要18个三角形（一个图片是由一个3*3网格渲染而成），然而，许多都需要渲染成一个顺滑的曲线。在实际应用上，二者并没有太大的区别。

 15.1.5 shadowPath
 
 如果图层是一个简单几何图形如矩形或者圆角矩形（假设不包含任何透明部分或者子图层），创建出一个对应形状的阴影路径就比较容易，而且Core Animation绘制这个阴影也相当简单，避免了屏幕外的图层部分的预排版需求。这对性能来说很有帮助。
 如果你的图层是一个更复杂的图形，生成正确的阴影路径可能就比较难了，这样子的话你可以考虑用绘图软件预先生成一个阴影背景图。
 */

/**
 15.2.1 混合和过渡绘制
 
 CPU每一帧可以绘制的像素有一个最大限制  就是所谓的 fillrate， 这个情况下可以轻易的绘制整个屏幕的所有像素。但是如果由于重叠图层的关系需要不停重绘同一区域的话，掉帧就可能发生了
 
 
 CPU会放弃绘制那些完全被其它图层遮挡的像素，但是要计算出一个图层是否被遮挡也是相当复杂并且会消耗处理器资源。同样，合并不同图层的透明重叠像素消耗的资源也是相当可观的。所以为了加速处理过程，不到必须时刻不要使用透明图层。任何情况下
 
 给视图的backgroundColor 属性设置一个固定的，不透明的颜色  设置opaque属性为YES
 
 这样做减少了混合行为（因为编译器知道在图层之后的东西都不会对最终的像素产生影响）并且计算得到了加速，避免了过渡绘制行为因为 core Animation 可以舍弃所有被完全遮盖住的图层  而不用每个像素都去计算一遍
 
 如果用到了图像，尽量避免透明除非非常必要。如果图像要显示在一个固定的背景颜色或是固定的背景图之前，你没必要相对前景移动，你只要预填充背景图片就可以避免运行时混色了
 
 明智的使用 shouldRasterize属性，可以将一个固定的图层体系折叠成单张图片，这样就不需要每一帧重新合成，也就不会有因为自图层之间的混合和过渡绘制的性能问题了
 */

/**
 
 15.3.1  减少图层数量
 
 初始化图层  处理图层  打包通过IPC发给渲染引擎，转化成OPenGL几何图形，这些是一个图层的大致资源开销。事实上，一次性能够在屏幕上显示的最大图层数也是有限制的。
 
 确切的说限制数量取决于iOS设备，图层类型，图层内容和属性等。
 
 
 15.3.2 裁切
 
 在对图层做优化之前  你需要确定亦不是在创建一些不可见的图层，图层在以下几种情况是不可见的
 图层在平民化边界之外，或是在父视图边界之外
 完全在一个不透明图层之后，
 完全透明
 
 Core Animation 非常擅长处理对视觉无效果意义的图层，但是经常性的，你自己的代码会比CoreAnimation更早的想知道一个图层是否有用的。  理想状态下，在图层对象创建之前就知道，以避免创建和配置不必要图层的额外工作。
 
 15.3.3 对象回收
 
 处理巨大数量的相似视图或图层时还有一个技巧就是回收他们。对象回收在iOS颇为常见；
 
 15.3.4 Core Graphics 绘制
 
 当排除掉对屏幕显示没有任何贡献的图层或者视图之后，长远看来，你可能仍然需要减少图层的数量。例如如果你正在使用多个UIlabel 或者 UIImageView 实例去显示固定内容，你可以把他们全部替换成一个单独的视图，然后用-drawRect：方法绘制出那些复杂的视图层级
 
 这个提议看上去并不合理因为大家都知道软件绘制行为要比GPU合成要慢而且还需要更多的内存空间，但是在因为图层数量而使得性能受限的情况下，软件绘制很可能提高性能呢，因为它避免了图层分配和操作问题。
 
 你可以自己实验一下这个情况，它包含了性能和栅格化的权衡，但是意味着你可以从图层树上去掉子图层（用shouldRasterize，与完全遮挡图层相反）。
 
 15.3.4 -renderInContext: 方
 
 用Core Graphics去绘制一个静态布局有时候会比用层级的UIView实例来得快，但是使用UIView实例要简单得多而且比用手写代码写出相同效果要可靠得多，更边说Interface Builder来得直接明了。为了性能而舍弃这些便利实在是不应该。
 
 幸好，你不必这样，如果大量的视图或者图层真的关联到了屏幕上将会是一个大问题。没有与图层树相关联的图层不会被送到渲染引擎，也没有性能问题（在他们被创建和配置之后）。
 
 使用CALayer的-renderInContext:方法，你可以将图层及其子图层快照进一个Core Graphics上下文然后得到一个图片，它可以直接显示在UIImageView中，或者作为另一个图层的contents。不同于shouldRasterize —— 要求图层与图层树相关联 —— ，这个方法没有持续的性能消耗。
 
 当图层内容改变时，刷新这张图片的机会取决于你（不同于shouldRasterize，它自动地处理缓存和缓存验证），但是一旦图片被生成，相比于让Core Animation处理一个复杂的图层树，你节省了相当客观的性能。
 
 重绘（每一帧用相同的像素填充多次）
 */
