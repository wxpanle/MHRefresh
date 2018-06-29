//
//  QYVectorPicture.m
//  MHRefresh
//
//  Created by panle on 2018/6/4.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYVectorPicture.h"

#define BRUSH_SIZE 32

@interface QYVectorPicture ()

@property (nonatomic, strong) NSMutableArray *strokes;

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation QYVectorPicture

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self vectorPicture];
    }
    return self;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)vectorPicture {
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.strokes = [NSMutableArray array];
    
//    _path = [[UIBezierPath alloc] init]; //
//    _path.lineJoinStyle = kCGLineJoinRound;
//    _path.lineCapStyle = kCGLineCapRound;
//
//    _path.lineWidth = 5;
    
//    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
//
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineJoin = kCALineJoinRound;
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.lineWidth = 5;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
//    [_path moveToPoint:point];
    
    [self addBurshStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
//    [_path addLineToPoint:point];
    
//    [self setNeedsDisplay];
//    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
    
     [self addBurshStrokeAtPoint:point];
}

- (void)drawRect:(CGRect)rect {
    
//    [[UIColor clearColor] setFill];
//    [[UIColor redColor] setStroke];
//    [_path stroke];
    
    for (NSValue *value in self.strokes) {
        
        CGPoint point = [value CGPointValue];
        
        CGRect burshRect = CGRectMake(point.x - BRUSH_SIZE / 2.0, point.y - BRUSH_SIZE / 2.0, BRUSH_SIZE, BRUSH_SIZE);
        
        [[UIImage imageNamed:@"ao1"] drawInRect:burshRect];
    }
}

- (void)addBurshStrokeAtPoint:(CGPoint)point {
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    [self setNeedsDisplay];
}

@end
