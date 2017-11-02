//
//  ProgressView.h
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
{
    CGFloat _angleInterval;
    NSTimer *timer;
    
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) float progressWidth;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) int mode;

@end
