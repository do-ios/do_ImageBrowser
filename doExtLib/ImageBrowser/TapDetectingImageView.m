//
//  TapDetectingImageView.m
//  doDebuger
//
//  Created by wl on 15/7/11.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "TapDetectingImageView.h"

@implementation TapDetectingImageView
{
    UITapGestureRecognizer *_singleTap;
    UITapGestureRecognizer *_doubleTap;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_singleTap];
        
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        _doubleTap.numberOfTouchesRequired = 1;
        _doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:_doubleTap];
        [_singleTap requireGestureRecognizerToFail:_doubleTap];
    }
    return self;
}

- (void)photoClick:(UITapGestureRecognizer *)touch
{
    if ([_detectDelegate respondsToSelector:@selector(singleTap)]) {
        [_detectDelegate performSelector:@selector(singleTap)];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)touch
{
    if ([_detectDelegate respondsToSelector:@selector(doubleTap:)]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [_detectDelegate performSelector:@selector(doubleTap:) withObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
    }
}

@end
