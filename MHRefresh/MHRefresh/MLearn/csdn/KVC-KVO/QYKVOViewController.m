//
//  QYKVOViewController.m
//  MHRefresh
//
//  Created by panle on 2018/2/5.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYKVOViewController.h"
#import "QYKVOModel.h"
#import "KeyValueObserver.h"

@interface QYKVOViewController ()

@property (nonatomic, strong) QYKVOModel *model;

@property (nonatomic, strong) id colorObserveToken;

@end

/*
 我们把视图控制器注册为观察者来接收 KVO 的通知，这可以用以下 NSObject 的方法来实现：
 
 - (void)addObserver:(NSObject *)anObserver
 forKeyPath:(NSString *)keyPath
 options:(NSKeyValueObservingOptions)options
 context:(void *)context
 
  在当 keyPath 的值改变的时候在观察者 anObserver 上面被调用。这个 API 看起来有一点吓人
 - (void)observeValueForKeyPath:(NSString *)keyPath
 ofObject:(id)object
 change:(NSDictionary *)change
 context:(void *)context
 
 移除观察者
 - (void)removeObserver:(NSObject *)anObserver
 forKeyPath:(NSString *)keyPath
 
 */

@implementation QYKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setModel:(QYKVOModel *)model {
    _model = model;
    self.colorObserveToken = [KeyValueObserver observeObject:model
                                                     keyPath:@"color"
                                                      target:self
                                                    selector:@selector(colorDidChange:)
                                                     options:NSKeyValueObservingOptionInitial];

}

- (void)colorDidChange:(NSDictionary *)change {
    
//    self.colorView.backgroundColor = self.labColor.color;
}



@end
