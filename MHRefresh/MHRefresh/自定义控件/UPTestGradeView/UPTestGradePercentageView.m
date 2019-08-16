//
//  UPTestGradePercentageView.m
//  Up
//
//  Created by panle on 2019/8/13.
//  Copyright © 2019 LanguoNetwork. All rights reserved.
//

#import "UPTestGradePercentageView.h"

static const CGFloat kViewH = 140.0;
static const CGFloat kViewW = 215.0;
static const CGFloat kStrokeW = 8.0;
static const CGFloat kLineW = 8.0;
static const CGFloat kLineSpace = 5.0;

static const CGFloat kRemindLBottom = 5.0;

static const NSInteger kLineNumber = 6;

#define j2h(x) (M_PI*(x)/180.0)

@interface UPTestGradePercentageView ()

@property (nonatomic, strong) CAShapeLayer *bgShapeLayer;

@property (nonatomic, strong) CAShapeLayer *progressBGLayer;
@property (nonatomic, strong) CAShapeLayer *progressShapeLayer;
@property (nonatomic, strong) CAGradientLayer *progressGradientLayer;

@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *lineShapeLayerArray;

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *remindLabel;

@end

@implementation UPTestGradePercentageView

#pragma mark - init

+ (instancetype)up_testGradePercentageView
{
    return [[UPTestGradePercentageView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutUPTestGradePercentageViewOfUI];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0.0, 0.0, kViewW, kViewH)];
}

- (void)up_updateWithProgress:(CGFloat)progress
{
    CGFloat endAngle = j2h((180 + 90 / kLineNumber * 2.0) * 0.5 + 180 - 90 / kLineNumber);
    UIBezierPath *bezierPatch = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.width / 2.0) radius:self.frame.size.width / 2.0 - kStrokeW startAngle:M_PI - (M_PI_2 / kLineNumber) endAngle:endAngle clockwise:YES];

    _progressShapeLayer.path = bezierPatch.CGPath;
    
    _progressGradientLayer.frame = CGRectMake(0, 0, self.frame.size.width * 0.5 + kStrokeW / 2.0, self.frame.size.height);
}


#pragma mark - layoutOfUI

- (void)layoutUPTestGradePercentageViewOfUI
{
    [self layoutUPTestGradePercentageViewUIOfSelf];
    [self layoutUPTestGradePercentageViewUIOfBgShapeLayer];
    [self layoutUPTestGradePercentageViewUIOfProgressShapeLayer];
    [self layoutUPTestGradePercentageViewUIOfLineShapeLayerArray];
    [self layoutUPTestGradePercentageViewUIOfProgressLabel];
    [self layoutUPTestGradePercentageViewUIOfRemindLabel];
    
    [self up_updateWithProgress:0.5];
}

- (void)layoutUPTestGradePercentageViewUIOfSelf
{
    self.backgroundColor = [UIColor blueColor];
}

- (void)layoutUPTestGradePercentageViewUIOfBgShapeLayer
{
    UIBezierPath *bezierPatch = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.width / 2.0) radius:self.frame.size.width / 2.0 - kStrokeW startAngle:M_PI - (M_PI_2 / kLineNumber) endAngle:0 + (M_PI_2 / kLineNumber) clockwise:YES];
    
    _bgShapeLayer = [CAShapeLayer layer];
    _bgShapeLayer.frame = self.bounds;
    _bgShapeLayer.lineWidth = kStrokeW;
    _bgShapeLayer.strokeColor = [UIColor redColor].CGColor;
    _bgShapeLayer.fillColor = [UIColor blueColor].CGColor;
    _bgShapeLayer.path = bezierPatch.CGPath;
    _bgShapeLayer.lineJoin = kCALineJoinRound;
    _bgShapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_bgShapeLayer];
}

- (void)layoutUPTestGradePercentageViewUIOfProgressShapeLayer
{
    _progressBGLayer = [CAShapeLayer layer];
    _progressBGLayer.lineJoin = kCALineJoinRound;
    _progressBGLayer.lineCap = kCALineJoinRound;
    
    _progressGradientLayer = [CAGradientLayer layer];
    _progressGradientLayer.startPoint = CGPointMake(0, 0.5);
    _progressGradientLayer.endPoint = CGPointMake(1.0, 0.5);
    _progressGradientLayer.colors = @[(id)[UIColor grayColor].CGColor, (id)[UIColor whiteColor].CGColor];
    
    [_progressBGLayer addSublayer:_progressGradientLayer];
    
    _progressShapeLayer = [CAShapeLayer layer];
    _progressShapeLayer.frame = self.bounds;
    _progressShapeLayer.lineWidth = kLineW;
    _progressShapeLayer.strokeColor = [UIColor greenColor].CGColor;
    _progressShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _progressShapeLayer.lineJoin = kCALineJoinRound;
    _progressShapeLayer.lineCap = kCALineCapRound;
    
    [_progressBGLayer setMask:_progressShapeLayer];
    
    [self.layer addSublayer:_progressBGLayer];
}

- (void)layoutUPTestGradePercentageViewUIOfLineShapeLayerArray
{
    NSInteger space = 90 / kLineNumber;
    NSInteger start = 180 - space;
    
    CGFloat centerX = self.frame.size.width / 2.0;
    CGFloat centerY = self.frame.size.width / 2.0;
    
    CGFloat outsideR = self.frame.size.width / 2.0 - kStrokeW - kLineSpace - kLineSpace;
    CGFloat innerR = self.frame.size.width / 2.0 - kStrokeW - kLineSpace - kLineW - kLineSpace;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezierPatch = [UIBezierPath bezierPath];
    layer.lineWidth = 2.0;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    for (; start <= 360 + space; start += space) {
        
        CGFloat outsideH = outsideR * CGFloat_fab(sin(j2h(start)));
        CGFloat innerH = innerR * CGFloat_fab(sin(j2h(start)));
        
        CGFloat outsideW = outsideR * CGFloat_fab(cos(j2h(start)));
        CGFloat innerW = innerR * CGFloat_fab(cos(j2h(start)));
        
        CGFloat outsideX = start < 270 ? centerX - outsideW : centerX + outsideW;
        CGFloat outsideY = (start < 180 || start > 360) ? centerY + outsideH : centerY - outsideH;
        
        CGFloat innerX = start < 270 ? centerX - innerW : centerX + innerW;
        CGFloat innerY = (start < 180 || start > 360) ? centerY + innerH : centerY - innerH;
        
        [bezierPatch moveToPoint:CGPointMake(outsideX, outsideY)];
        [bezierPatch addLineToPoint:CGPointMake(innerX, innerY)];
    }
    
    layer.frame = self.bounds;
    layer.path = bezierPatch.CGPath;
    [self.layer addSublayer:layer];
}

- (void)layoutUPTestGradePercentageViewUIOfProgressLabel
{
    
}

- (void)layoutUPTestGradePercentageViewUIOfRemindLabel
{
    
}


@end
