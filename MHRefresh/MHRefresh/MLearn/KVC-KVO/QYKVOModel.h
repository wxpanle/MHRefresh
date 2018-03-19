//
//  QYKVOModel.h
//  MHRefresh
//
//  Created by panle on 2018/2/5.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 观察model对象的变化
 MVC: 控制器负责让视图和模型同步 1.当model对象改变的时候，视图应该随之改变反映模型的变化 2.当用户和控制器交互的时候，模型也应该做出相应的改变
 KVO 可以实现观察视图依赖的属性变化
 
 Foundation 框架提供的表示属性依赖的机制如下：
 + (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
 + (NSSet *)keyPathsForValuesAffecting<键名>
 
 */

@interface QYKVOModel : NSObject

@property (nonatomic, assign) double lComponent;

@property (nonatomic, assign) double aComponent;

@property (nonatomic, assign) double bComponent;

@property (nonatomic, assign, readonly) double redComponent;

@property (nonatomic, assign, readonly) double greenComponent;

@property (nonatomic, assign, readonly) double blueComponent;

@property (nonatomic, strong, readonly) UIColor *color;


@end


/*
 手动通知 vc 自动通知
 
 当setLComponent:等方法被调用的时候  - (void)willChangeValueForKey:(NSString *)key
 - (void)didChangeValueForKey:(NSString *)key  会在代码之前和之后被调用
 
 如果重写 setLComponent  并且需要控制是否发送键值改变的通知的时候
 + (BOOL)automaticallyNotifiesObserversForLComponent;
 {
 return NO;
 }
 
 - (void)setLComponent:(double)lComponent;
 {
 if (_lComponent == lComponent) {
 return;
 }
 [self willChangeValueForKey:@"lComponent"];
 _lComponent = lComponent;
 [self didChangeValueForKey:@"lComponent"];
 }
 
 关闭 -willChangeValueForKey: 和 -didChangeValueForKey: 的自动调用 然后我们手动的调用它们  我们只应该在关闭了自动调用的时候我们才在setter方法里手动调用 -willChangeValueForKey: 和 -didChangeValueForKey:
 
 
 如果我们在存储器方法之外改变实例对象
 
 */

/*
 KVO context
 
 如果我们在实现一个类的时候把它自己变为注册者的话 需要传入一个这个类唯一的context
 static int const PrivateKVOContext 写在.m的顶端
 
 [otherObject addObserver:self forKeyPath:@"someKey" options:someOptions context:&PrivateKVOContext];
 
 然后我们这样写 -observeValueForKeyPath:... 的方法：
 
 - (void)observeValueForKeyPath:(NSString *)keyPath
 ofObject:(id)object
 change:(NSDictionary *)change
 context:(void *)context
 {
 if (context == &PrivateKVOContext) {
 // 这里写相关的观察代码
 } else {
 [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
 }
 }
 这将确保我们写的子类都是正确的。如此一来，子类和父类都能安全的观察同样的键值而不会冲突。否则我们将会碰到难以 debug 的奇怪行为。
 
 */

/*
 进阶KVO
 
 我们常常需要当一个值改变的时候更新UI  但是我们也要在第一次运行代码的时候更新一次UI  我们可以使用KVO并添加NSKeyValueObservingOptionInitial选项来一箭双雕。
 
 之前和之后
 NSKeyValueObservingOptionPrior 键值改变之前被通知
 
 if ([change[NSKeyValueChangeNotificationIsPriorKey] boolValue]) {
 // 改变之前
 } else {
 // 改变之后
 }
 
 值
 如果我们需要改变之后的值  NSKeyValueObservingOptionNew 和/或 NSKeyValueObservingOptionOld。
 
 id oldValue = change[NSKeyValueChangeOldKey];
 id newValue = change[NSKeyValueChangeNewKey];
 
 索引
 -mutableArrayValueForKey:
 -mutableSetValueForKey:
 -mutableOrderedSetValueForKey:
 
 */

/*
 KVO和线程
 
 KVO行为是同步的   并且发生与所观察的值发生变化同样的线程上  没有队列或者run-loop处理  手动或者自动调用-didChange... 会触发 KVO 通知。
 
 当我们试图从其它线程改变属性值得时候我们应当十分小心，除非能确定所有的观察者都用线程安全的方法处理KVO通知
 
 其次，如果某个键被观察的时候附上了 NSKeyValueObservingOptionPrior 选项，直到 -observe... 被调用之前， exchangeRate 的 accessor 方法都会返回同样的值。
 
 */

/*
 KVC 允许我们用属性的字符串名称来访问属性，字符串被称为键
 
 //键路径  Key Path
 KVC 同样允许我们通过关系来访问对象
 假设person对象有属性address，address有属性city，  [person valueForKeyPath:@"address.city"]
 
 
 key-value Coding Without @property  不需要@property 的  KVC
 手写getter和setter方法  等价于@property
 - (NSString *)name;
 - (void)setName:(NSString *)name;
 
 但是当标量和 struct 的值被传入 nil 的时候尤其需要注意。假设我们要 height 属性支持 KVC 我们写了以下的方法：
 - (CGFloat)height;
 - (void)setHeight:(CGFloat)height;
 [object setValue:nil forKey:@"height"]
 
 这会抛出一个 exception。要正确的处理 nil，我们要像这样 override -setNilValueForKey:
 
 - (void)setNilValueForKey:(NSString *)key
 {
 if ([key isEqualToString:@"height"]) {
 [self setValue:@0 forKey:key];
 } else
 [super setNilValueForKey:key];
 }
 
 
 我们可以通过重写方法来让一个类支持KVC
 - (id)valueForUndefinedKey:(NSString *)key;  //未定义的key
 - (void)setValue:(id)value forUndefinedKey:(NSString *)key;
 
 可以让一个类动态支持一些键的访问  会造成性能上的瓶颈
 
 
 //集合的操作
 
 一个常常被忽视的KVC特性是它对集合操作的支持。
 
 获取数组中的最大值
 NSArray *a = @[@4, @84, @2];
 NSLog(@"max = %@", [a valueForKeyPath:@"@max.self"]);
 
 我们有一个transaction对象的数组，对象有属性amount的话，我们可以这样获得最大的amount
 NSArray *a = @[transaction1, transaction2, transaction3];
 NSLog(@"max = %@", [a valueForKeyPath:@"@max.amount"]);
 当我们调用[a valueForKeyPath:@"@max.amount"]的时候，它会在数组a的每个元素中调用 valueForKey:@"amount" 然后返回最大的那个
 
 
 //通过集合代理对象来实现KVC
 我们可以像对待一般的对象那样用KVC深入集合内部（NSArray和NSSet）但是通过集合代理对象，KVC也让我们实现一个兼容KVC的集合，这是一个颇为高端技巧
 
 当我们在对象上调用valueForKey: 的时候，它可以返回NSArray NSSet  NSOrderedSet的集合代理对象，这个类没有实现通常的 <key>方法   但是它实现了代理对象所需要的使用的很多方法
 
 如果我们希望一个类支持通过代理飞翔的contacts键返回一个数组  我们可以这样写
 - (NSUInteger)countOfContacts;
 - (id)objectInContactsAtIndex:(NSUInteger)idx;
 当我们调用[object valueForKey:@"contacts”]的时候，它会返回一个由这两个方法来代理所有调用方法的NSArray对象。这个数组支持所有正常的对NSArray的操作。换句话说  调用者并不知道返回的是一个真正的NSArray  还是一个代理的数组
 
 对于NSSet  NSOrderedSet  如果想要做同样的事情  我们需要实现的方法是
 NSArray -countOf<key>   -objectIn<Key>AtIndex: -(Key)AtIndex:    -get<key>:range:
 NSSet  -countOf<Key>   -enumeratorOf<key>  -memoryOf<Key>:
 NSOrderedSet   -countOf<key>  -indexIn<Key>ofObject:  -objectIn<Key>AtIndex:  - <Key>AtINdexs: -get<key>:range:
 
 只有在特殊的情况下才会使用这些代理对象 
 
 */


/*
 可变的集合
 
 我们也可以在可变集合（NSMutableArray NSMutableSet NSMutableOrderdSet）中用集合代理
 - (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;
 - (NSMutableSet *)mutableSetValueForKey:(NSString *)key;
 - (NSMutableOrderedSet *)mutableOrderedSetValueForKey:(NSString *)key;
 
 - (NSMutableArray *)mutableContacts;
 {
 return [self mutableArrayValueForKey:@"wrappedContacts"];
 }
 我们需要实现上面的不变集合的两个方法，还有以下的几个：
 
 NSMutableArray / NSMutableOrderedSet           NSMutableSet
 至少实现一个插入方法和一个删除方法    至少实现一个插入方法和一个删除方法
 -insertObject:in<Key>AtIndex:    -add<Key>Object:
 -removeObjectFrom<Key>AtIndex:    -remove<Key>Object:
 -insert<Key>:atIndexes:    -add<Key>:
 -remove<Key>AtIndexes:    -remove<Key>:
 可选（增强性能）以下方法二选一    可选（增强性能）
 -replaceObjectIn<Key>AtIndex:withObject:    -intersect<Key>:
 -replace<Key>AtIndexes:with<Key>:    -set<Key>:
 
 要对自动更新和手动更新KVO之间的差别十分小心  Foundation  默认自动发出十分相近的变化通知
 
 */




