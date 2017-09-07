//
//  MCameraController.h
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MImagePickerHeader.h"

@interface MCameraController : UIViewController

@property (nonatomic, weak) id <MImagePickerControllerDelegate> delegate;

@end
