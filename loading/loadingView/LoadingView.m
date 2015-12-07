//
//  LoadingView.m
//  loading
//
//  Created by liangqi on 15/12/7.
//  Copyright © 2015年 dailyios. All rights reserved.
//


#import "LoadingView.h"

// loading 默认大小
#define kLoadingSize CGRectMake(0,0,50, 50)

// loading 线条宽度
static const CGFloat kLineWidth =  3.0f;
static NSString* const kRoateAnimation = @"com.dailyios.loading.rotate_animate";
static NSString* const kLayerAnimation = @"com.dailyios.loading.layer_animate";

@interface LoadingView()

@property(nonatomic,strong) CAShapeLayer *loadingLayer;
@property(nonatomic,strong) CAMediaTimingFunction *timeFunc;
@property(nonatomic,assign) BOOL isAnimating;

@end

@implementation LoadingView

+ (instancetype)instance{
    return [[self alloc] initWithFrame:kLoadingSize];
}

- (void)setClockwise:(BOOL)clockwise{
    _clockwise = clockwise;
    [self resetAnimate];
}

- (void) resetAnimate{
    if (self.isAnimating) {
        [self stopAnimate];
    }
    
    [self renderPath];
    [self startAnimate];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void) setup:(CGRect) frame {
    // 动画默认顺时针旋转
    _clockwise = YES;
    _timeFunc = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _loadingLayer = [self getLayer:frame];
    [self.layer addSublayer:_loadingLayer];
    
    [self renderPath];
    [self startAnimate];
}

- (CAShapeLayer *) getLayer:(CGRect) frame{
    CAShapeLayer *loadingLayer = [CAShapeLayer new];
    loadingLayer.frame = frame;
    loadingLayer.lineWidth = kLineWidth;
    loadingLayer.fillColor = [UIColor clearColor].CGColor;
    loadingLayer.lineCap = kCALineCapRound;
    loadingLayer.strokeColor = self.tintColor.CGColor;

    return loadingLayer;
}

- (void)tintColorDidChange{
    [super tintColorDidChange];
    _loadingLayer.strokeColor = self.tintColor.CGColor;
}

- (void)startAnimate{
    [self renderAnimate];
    _isAnimating = YES;
}

- (void)stopAnimate{
    _isAnimating = NO;
    [self.loadingLayer removeAnimationForKey:kRoateAnimation];
    [self.loadingLayer removeAnimationForKey:kLayerAnimation];
}

/**
 *  绘制初始化圆弧
 */
- (void) renderPath{
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetWidth(self.bounds) / 2);
    CGFloat raduis = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetMaxX(self.bounds) / 2 - self.loadingLayer.lineWidth);
    
    CGFloat startAngle = 0;
    CGFloat endAngle = M_PI * 2;
    
    if (!_clockwise) {
        startAngle = M_PI * 2;
        endAngle = 0;
    }
    
    // 使用贝塞尔曲线绘制弧线圆圈
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:raduis startAngle:startAngle endAngle:endAngle clockwise:_clockwise];
    
    self.loadingLayer.path = path.CGPath;
    self.loadingLayer.strokeStart = 0.0f;
    self.loadingLayer.strokeEnd = 0.5f;
    
}

- (void) renderAnimate{
    if (_isAnimating) return;
    
    // 全局旋转
    CABasicAnimation *rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform.rotation";
    if (_clockwise) {
        rotate.fromValue = @0.0f;
        rotate.toValue = @(2 * M_PI);
    } else {
        rotate.fromValue = @(2 * M_PI);
        rotate.toValue = @0.0f;
    }
    
    rotate.duration = 4.0f;
    rotate.repeatCount = INFINITY;
    rotate.removedOnCompletion = NO;
    [_loadingLayer addAnimation:rotate forKey:kRoateAnimation];

    // 路径动画
    CABasicAnimation *beginFirst = [CABasicAnimation animation];
    beginFirst.timingFunction = _timeFunc;
    beginFirst.duration = 1.0f;
    beginFirst.fromValue = @0.0f;
    beginFirst.toValue = @0.25f;
    beginFirst.keyPath = @"strokeStart";
    
    CABasicAnimation *beginSecond = [CABasicAnimation animation];
    beginSecond.timingFunction = _timeFunc;
    beginSecond.beginTime = 1.0f;
    beginSecond.duration = 0.5f;
    beginSecond.fromValue = @0.25f;
    beginSecond.toValue = @1.0f;
    beginSecond.keyPath = @"strokeStart";
    
    CABasicAnimation *endFirst = [CABasicAnimation animation];
    endFirst.timingFunction = _timeFunc;
    endFirst.duration = 1.0f;
    endFirst.fromValue = @0.0f;
    endFirst.toValue = @1.0f;
    endFirst.keyPath = @"strokeEnd";
    
    CABasicAnimation *endSecond = [CABasicAnimation animation];
    endSecond.timingFunction = _timeFunc;
    endSecond.duration = 0.5f;
    endSecond.beginTime = 1.0f;
    endSecond.fromValue = @1.0f;
    endSecond.toValue = @1.0f;
    endSecond.keyPath = @"strokeEnd";
    
    CAAnimationGroup *group  = [CAAnimationGroup animation];
    group.animations = @[beginFirst,beginSecond,endFirst,endSecond];
    group.duration = 1.5f;
    group.removedOnCompletion = NO;
    group.repeatCount = INFINITY;
    
    [_loadingLayer addAnimation:group forKey:kLayerAnimation];
    
}




@end
