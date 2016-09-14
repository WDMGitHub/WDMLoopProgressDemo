//
//  LoopProgressView.m
//  DMLoopProgressDemo
//
//  Created by wangdemin on 16/9/14.
//  Copyright © 2016年 Demin. All rights reserved.
//

/**
 *  1.NSTimer的调用并非精准
 *  2.这里因为每0.01s启动一次定时器，所以要同步进度条和数字，就将self.progress赋值给动画的duration属性就可以了，duration为动画时间
 *  3.在使用时我发现如果在tableViewCell中添加了这个环形进度条时有个缺点，就是定时器原本用的是系统的runloop，导致数据显示滞后，所以现更新为子线程里添加定时器，子线程的定时器必须添加[[NSRunLoop currentRunLoop] run]，才可以启动定时器，因为子线程的runLoop里是不带NSTimer的，需要手动添加运行
 */
#import "LoopProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define ViewWidth self.frame.size.width  //环形进度条的视图宽度
#define ProgressWidth 40                 //环形进度条的圆环宽度
#define Radius ViewWidth/2-ProgressWidth //环形进度条的半径

@interface LoopProgressView ()
{
    CAShapeLayer *arcLayer;
    UILabel *label;
    NSTimer *progressTimer;
}

@property (nonatomic, assign) NSInteger i;

@end

@implementation LoopProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _i = 0;
    CGContextRef progressContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(progressContext, ProgressWidth);
    CGContextSetRGBStrokeColor(progressContext, 209/255.0, 209/255.0, 209/255.0, 1);
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    //绘制环形进度条底框
    CGContextAddArc(progressContext, xCenter, yCenter, Radius, 0, 2 * M_PI, 0);
    CGContextDrawPath(progressContext, kCGPathStroke);
    
    //绘制环形进度条
    CGFloat to = M_PI * 2;
    //进度数字字号，可以根据自己需要，从视图大小去适配字体字号
    int fontNum = ViewWidth / 5;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Radius + 10, ViewWidth / 6)];
    label.center = CGPointMake(xCenter, yCenter);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:fontNum];
    label.text = @"0";
    [self addSubview:label];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(xCenter, yCenter) radius:Radius startAngle:0 endAngle:to clockwise:YES];
    
    //创建出CAShapeLayer的实例
    arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;
    arcLayer.fillColor = [UIColor clearColor].CGColor;
    arcLayer.strokeColor = [UIColor colorWithRed:75/255.0 green:208/255.0 blue:150/255.0 alpha:1].CGColor;
    arcLayer.lineWidth = ProgressWidth;
    arcLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:arcLayer];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self drawLineAnimation:arcLayer];
    });
    
    if (self.progress < 0)
    {
        NSLog(@"传入数值范围为 0-1");
        self.progress = 0;
        return;
    }
    
    if (self.progress > 0)
    {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
        [thread start];
    }
}

- (void)newThread
{
    @autoreleasepool
    {
        progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

//NSTimer不会精准调用
- (void)timeLabel
{
    _i += 1;
    label.text = [NSString stringWithFormat:@"%zd", _i];
    if (_i >= self.progress)
    {
        [progressTimer invalidate];
        progressTimer = nil;
        [self dismissAnimation];
    }
}

//定义动画过程
- (void)drawLineAnimation:(CALayer *)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = self.progress; //动画时间
    NSLog(@"%zd",self.progress);
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)dismissAnimation
{
    [UIView animateWithDuration:2 animations:^{
        //（缩放:设置缩放比例）仅通过设置缩放比例就可实现视图扑面而来和缩进频幕的效果
        self.transform = CGAffineTransformMakeScale(10.0f, 10.0f);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
