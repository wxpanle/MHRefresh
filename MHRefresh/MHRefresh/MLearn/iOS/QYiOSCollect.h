//
//  QYiOSCollect.h
//  MHRefresh
//
//  Created by panle on 2018/6/7.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface QYiOSCollect : NSObject
@end

#pragma mark - ===== oc基础 =====

/** 如何在struct中使用OC对象
 
 ARC forbids Objective-C objects in structs
 
 __unsafeunretained 所有权修饰符 是不安全的所有权修饰符 不属于 编译器的内存管理对象 同weak一样，生成的对象不会自己持有 ARC下 生成的对象会被立即释放 不同的是weak会将对象置为nil  __unsafeunretained 不会置空 此时访问该对象依然可以访问 但会造成运行时错误 即悬垂指针
 
 详见补充  ARC 规则
 */


#pragma mark - ===== seift 基础 =====



#pragma mark - ===== 补充 =====

/** ARC 规则变迁
 
 1.引用计数式内存管理
 
 在编译上 可以设置ARC有效或者无效，一个应用程序里可以混合ARC有效或者无效的二进制形式
 ·使用clang（LLVM编译器）3.0及以上的版本
 ·指定编译属性为 ‘-fobjc-arc’
 
 2. 内存管理的思考方式
 
 ·自己生成的对象，自己持有
 ·非自己生成的对象，自己可以持有
 ·自己持有的对象不再需要时要进行释放
 ·非自己持有的对象无法释放
 
 3.所有权修饰符
 
 oc为了处理对象，可将变量类型定义为id或者各种对象类型
 
 所谓对象类型就是只想NSObject这样的oc类的指针。如 NSObject*  id类型用于隐藏对象类型的类名部分，相当于c语言中的void*
 ARC有效时， id 类型 和 对象类型同c语言其它类型不同，且类型上必须附加所有权修饰符。
 
 所有权修饰符一共有4种，
 ·__strong   ·__weak   ·__unsafe__unretained  ·__autoreleasing
 
 3.1 __strong
 
 __strong 是id和对象类型默认的所有权修饰符。也就是说， 源代码中的id变量  实际上都被添加了所有权修饰符。

 */


