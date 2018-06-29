//
//  QYEightTKnowedge.h
//  MHRefresh
//
//  Created by panle on 2018/5/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYEightTKnowedge : NSObject

@end

/**
 第八章 显示动画
 
 */

/**
 8.1 属性动画
 
 CAAnimationDelegate在任何头文件中都找不到，但是可以在CAAnimation头文件或者苹果开发者文档中找到相关函数。在这个例子中，我们用-animationDidStop:finished:方法在动画结束之后来更新图层的backgroundColor。
 
 当更新属性的时候，我们需要设置一个新的事务，并且禁用图层行为。否则动画会发生两次，一个是因为显式的CABasicAnimation，另一次是因为隐式动画，
 
 对CAAnimation而言，使用委托模式而不是一个完成块会带来一个问题，就是当你有多个动画的时候，无法在在回调方法中区分。在一个视图控制器中创建动画的时候，通常会用控制器本身作为一个委托（如清单8.3所示），但是所有的动画都会调用同一个回调方法，所以你就需要判断到底是那个图层的调用。
 
 动画本身会作为一个参数传入委托的方法，也许你会认为可以控制器中把动画存储为一个属性，然后在回调用比较，但实际上并不起作用，因为委托传入的动画参数是原始值的一个深拷贝，从而不是同一个值。
 
 当使用-addAnimation:forKey:把动画添加到图层，这里有一个到目前为止我们都设置为nil的key参数。这里的键是-animationForKey:方法找到对应动画的唯一标识符，而当前动画的所有键都可以用animationKeys获取。如果我们对每个动画都关联一个唯一的键，就可以对每个图层循环所有键，然后调用-animationForKey:来比对结果。尽管这不是一个优雅的实现。
 
 幸运的是，还有一种更加简单的方法。像所有的NSObject子类一样，CAAnimation实现了KVC（键-值-编码）协议，于是你可以用-setValue:forKey:和-valueForKey:方法来存取属性。但是CAAnimation有一个不同的性能：它更像一个NSDictionary，可以让你随意设置键值对，即使和你使用的动画类所声明的属性并不匹配。
 
 8.1.1 关键帧动画
 
 CABasicAnimation揭示了大多数隐式动画背后依赖的机制，这的确很有趣，但是显式地给图层添加CABasicAnimation相较于隐式动画而言，只能说费力不讨好。
 
 CAKeyframeAnimation是另一种UIKit没有暴露出来但功能强大的类。和CABasicAnimation类似，CAKeyframeAnimation同样是CAPropertyAnimation的一个子类，它依然作用于单一的一个属性，但是和CABasicAnimation不一样的是，它不限制于设置一个起始和结束的值，而是可以根据一连串随意的值来做动画。
 
 关键帧起源于传动动画，意思是指主导的动画在显著改变发生时重绘当前帧（也就是关键帧），每帧之间剩下的绘制（可以通过关键帧推算出）将由熟练的艺术家来完成。CAKeyframeAnimation也是同样的道理：你提供了显著的帧，然后Core Animation在每帧之间进行插入。
 
 注意到序列中开始和结束的颜色都是蓝色，这是因为CAKeyframeAnimation并不能自动把当前值作为第一帧（就像CABasicAnimation那样把fromValue设为nil）。动画会在开始的时候突然跳转到第一帧的值，然后在动画结束的时候突然恢复到原始的值。所以为了动画的平滑特性，我们需要开始和结束的关键帧来匹配当前属性的值。
 
 当然可以创建一个结束和开始值不同的动画，那样的话就需要在动画启动之前手动更新属性和最后一帧的值保持一致，就和之前讨论的一样。
 
 提供一个数组的值就可以按照颜色变化做动画，但一般来说用数组来描述动画运动并不直观。CAKeyframeAnimation有另一种方式去指定动画，就是使用CGPath。path属性可以用一种直观的方式，使用Core Graphics函数定义运动序列来绘制动画。
 
 8.1.2 虚拟属性
 
 属性动画实际上是针对于关键路径而不是一个键，这就意味着可以对子属性甚至是虚拟属性做动画
 
 用transform.rotation而不是transform做动画的好处如下：
 我们可以不通过关键帧一步旋转多于180度的动画。
 可以用相对值而不是绝对值旋转（设置byValue而不是toValue）。
 可以不用创建CATransform3D，而是使用一个简单的数值来指定角度。
 不会和transform.position或者transform.scale冲突（同样是使用关键路径来做独立的动画属性）。

 transform.rotation属性有一个奇怪的问题是它其实并不存在。这是因为CATransform3D并不是一个对象，它实际上是一个结构体，也没有符合KVC相关属性，transform.rotation实际上是一个CALayer用于处理动画变换的虚拟属性。
 
 你不可以直接设置transform.rotation或者transform.scale，他们不能被直接使用。当你对他们做动画时，Core Animation自动地根据通过CAValueFunction来计算的值来更新transform属性。
 
 CAValueFunction用于把我们赋给虚拟的transform.rotation简单浮点值转换成真正的用于摆放图层的CATransform3D矩阵值。你可以通过设置CAPropertyAnimation的valueFunction属性来改变，于是你设置的函数将会覆盖默认的函数。
 
 CAValueFunction看起来似乎是对那些不能简单相加的属性（例如变换矩阵）做动画的非常有用的机制，但由于CAValueFunction的实现细节是私有的，所以目前不能通过继承它来自定义。你可以通过使用苹果目前已经提供的常量（目前都是和变换矩阵的虚拟属性相关，所以没太多使用场景了，因为这些属性都有了默认的实现方式）。
 */


/**
 8.2 动画组
 
 CABasicAnimation和CAKeyframeAnimation仅仅作用于单独的属性，而CAAnimationGroup可以把这些动画组合在一起。CAAnimationGroup是另一个继承于CAAnimation的子类，它添加了一个animations数组的属性，用来组合别的动画。
 */


/**
 8.3 过渡
 
 有时候对于iOS应用程序来说，希望能通过属性动画来对比较难做动画的布局进行一些改变。比如交换一段文本和图片，或者用一段网格视图来替换，等等。属性动画只对图层的可动画属性起作用，所以如果要改变一个不能动画的属性（比如图片），或者从层级关系中添加或者移除图层，属性动画将不起作用。
 
 于是就有了过渡的概念。过渡并不像属性动画那样平滑地在两个值之间做动画，而是影响到整个图层的变化。过渡动画首先展示之前的图层外观，然后通过一个交换过渡到新的外观。
 
 为了创建一个过渡动画，我们将使用CATransition，同样是另一个CAAnimation的子类，和别的子类不同，CATransition有一个type和subtype来标识变换效果。type属性是一个NSString类型，可以被设置成如下类型：
 kCATransitionFade
 kCATransitionMoveIn
 kCATransitionPush
 kCATransitionReveal
 
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromTop
 kCATransitionFromBottom
 
 8.3.1 隐式过渡
 
 CATransision可以对图层任何变化平滑过渡的事实使得它成为那些不好做动画的属性图层行为的理想候选。苹果当然意识到了这点，并且当设置了CALayer的content属性的时候，CATransition的确是默认的行为。但是对于视图关联的图层，或者是其他隐式动画的行为，这个特性依然是被禁用的，但是对于你自己创建的图层，这意味着对图层contents图片做的改动都会自动附上淡入淡出的动画。
 
 8.3.2 对图层树的动画
 
 CATransition并不作用于指定的图层属性，这就是说你可以在即使不能准确得知改变了什么的情况下对图层做动画，例如，在不知道UITableView哪一行被添加或者删除的情况下，直接就可以平滑地刷新它，或者在不知道UIViewController内部的视图层级的情况下对两个不同的实例做过渡动画。
 
 这些例子和我们之前所讨论的情况完全不同，因为它们不仅涉及到图层的属性，而且是整个图层树的改变--我们在这种动画的过程中手动在层级关系中添加或者移除图层。
 
 这里用到了一个小诡计，要确保CATransition添加到的图层在过渡动画发生时不会在树状结构中被移除，否则CATransition将会和图层一起被移除。一般来说，你只需要将动画添加到被影响图层的superlayer。

 
 8.3.3 自定义动画
 
 我们证实了过渡是一种对那些不太好做平滑动画属性的强大工具，但是CATransition的提供的动画类型太少了。
 
 更奇怪的是苹果通过UIView +transitionFromView:toView:duration:options:completion:和+transitionWithView:duration:options:animations:方法提供了Core Animation的过渡特性。但是这里的可用的过渡选项和CATransition的type属性提供的常量完全不同。UIView过渡方法中options参数可以由如下常量指定：
 UIViewAnimationOptionTransitionFlipFromLeft
 UIViewAnimationOptionTransitionFlipFromRight UIViewAnimationOptionTransitionCurlUp UIViewAnimationOptionTransitionCurlDown UIViewAnimationOptionTransitionCrossDissolve UIViewAnimationOptionTransitionFlipFromTop UIViewAnimationOptionTransitionFlipFromBottom
 
 除了UIViewAnimationOptionTransitionCrossDissolve之外，剩下的值和CATransition类型完全没关系。
 
 这里有个警告：-renderInContext:捕获了图层的图片和子图层，但是不能对子图层正确地处理变换效果，而且对视频和OpenGL内容也不起作用。但是用CATransition，或者用私有的截屏方式就没有这个限制了。


 */

/**
 8.4 在动画过程中取消动画
 
 之前提到过，你可以用-addAnimation:forKey:方法中的key参数来在添加动画之后检索一个动画，使用如下方法：
 - (CAAnimation *)animationForKey:(NSString *)key;
 
 但并不支持在动画运行过程中修改动画，所以这个方法主要用来检测动画的属性，或者判断它是否被添加到当前图层中。
 
 为了终止一个指定的动画，你可以用如下方法把它从图层移除掉：
 - (void)removeAnimationForKey:(NSString *)key;
 
 或者移除所有动画：
 - (void)removeAllAnimations;
 
 动画一旦被移除，图层的外观就立刻更新到当前的模型图层的值。一般说来，动画在结束之后被自动移除，除非设置removedOnCompletion为NO，如果你设置动画在结束之后不被自动移除，那么当它不需要的时候你要手动移除它；否则它会一直存在于内存中，直到图层被销毁。
 
 我们来扩展之前旋转飞船的示例，这里添加一个按钮来停止或者启动动画。这一次我们用一个非nil的值作为动画的键，以便之后可以移除它。-animationDidStop:finished:方法中的flag参数表明了动画是自然结束还是被打断，我们可以在控制台打印出来。如果你用停止按钮来终止动画，它会打印NO，如果允许它完成，它会打印YES。
 */


