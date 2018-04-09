//
//  YXCollectionViewCell.h
//  Annotation
//
//  Created by zyx on 2017/5/2.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CellType) {
    CellTypeOfShape,
    CellTypeOfColor,
};

@interface YXCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CellType type;


- (void)setCellType:(CellType)type style:(id)style;

@end
