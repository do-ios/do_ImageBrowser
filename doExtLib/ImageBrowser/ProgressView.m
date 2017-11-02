//
//  ProgressView.m
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import "ProgressView.h"
#import "ImageBrowserConfig.h"


@implementation ProgressView
{
    NSInteger num;
    
    UILabel *percent;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super init];
    if (self) {
        _trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = self.bounds;
        
        _progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;

        self.progressWidth = 5;
        
        percent = [UILabel new];
        percent.font = [UIFont systemFontOfSize:16];
        percent.backgroundColor = [UIColor clearColor];
        [percent setTextColor:[UIColor whiteColor]];
        percent.textAlignment = NSTextAlignmentCenter;
        [self addSubview:percent];
        

    }
    return self;
}
- (CGPoint)getCenter
{
    CGFloat hW = CGRectGetWidth(self.frame)/2;
    CGFloat hH = CGRectGetHeight(self.frame)/2;
    CGPoint center = CGPointMake(hW, hH);
    
    return center;
}

- (void)setTrack
{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:[self getCenter] radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:0 endAngle:M_PI*2 clockwise:YES];;
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress
{
    num++;
    _progressPath = [UIBezierPath bezierPathWithArcCenter:[self getCenter] radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:M_PI_2/2*num endAngle:M_PI_2/2*(num+1) clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
}

- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
    [self setProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(CGFloat)progresss
{
    if (_progress>1) {
        _progress = 1;
    }else if (_progress<0) {
        _progress = 0;
    }
    if ((progresss - _progress)<.1) {
        return;
    }
    _progress = progresss;
    
    [self setProgress];
    if (percent.frame.size.width == 0) {
        percent.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        percent.center = [self getCenter];
    }
    
    [percent setText:[NSString stringWithFormat:@"%.0lf %%",_progress*100]];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    
}

- (void)changeAngle
{
    _angleInterval += M_PI * 0.08;
    if (_angleInterval >= M_PI * 2) _angleInterval = 0;
        [self setProgress];
}

@end
