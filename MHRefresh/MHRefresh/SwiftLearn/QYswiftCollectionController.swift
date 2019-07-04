//
//  QYswiftCollectionController.swift
//  MHRefresh
//
//  Created by panle on 2019/6/24.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class QYswiftCollectionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        p_array()
    }
    
    //数组
    private func p_array() -> Void {
        //数组和可变性
        
        //数组是一个容器，它以有序的方式存储一系列相同e类型的元素，对于其中每个元素，我们可以使用下标对其直接进行访问
        
        let fibs = [0, 1, 1, 2, 3, 5];  //let 声明  无法更改内容
        
        var mutableFibs = [0, 1, 1, 2, 3, 5]
        mutableFibs.append(8)
        mutableFibs.append(contentsOf: [13, 21])
        print("\(mutableFibs)")
        
        //let定义的变量具有不可变性  但对于引用来说  所引用的对象是可以改变的
        
        var x = [1, 2, 3]
        var y = x
        y.append(4)
        print("y = \(y), x = \(x)")
        
        let a = NSMutableArray.init(array: [1, 2, 3])
        let b: NSArray = a
        a.insert(9, at: 0)
        print("b = \(b)")
    }
}
