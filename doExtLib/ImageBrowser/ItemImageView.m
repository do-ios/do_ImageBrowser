//
//  ItemImageView.m
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import "ItemImageView.h"
#import "ProgressView.h"
#import "ImageBrowserConfig.h"
#import "UIImageView+DOWebCache.h"
#import "TapDetectingImageView.h"

@interface ItemImageView ()<UIScrollViewDelegate,TapDetectingDelegate>

@end

@implementation ItemImageView
{
    ProgressView *_waitingView;
    BOOL _didCheckSize;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
    TapDetectingImageView *_zoomingImageView;

    CGFloat _totalScale;
    
    CGSize contentSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        
        // 捏合手势缩放图片
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (BOOL)isScaled
{
    return  1.0 != _totalScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    _currentURL = url;
    [self removeWaitingView];
    
    ProgressView *waiting = [[ProgressView alloc] init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    waiting.bounds = CGRectMake(0, 0, screenWidth/6, screenWidth/6);
    waiting.mode = ProgressViewProgressMode;
    
    waiting.trackColor = [UIColor colorWithRed:197 green:197 blue:197 alpha:.2];
    waiting.progressColor = [UIColor whiteColor];
    waiting.progress = 0;
    waiting.progressWidth = 5;
    _waitingView = waiting;
    [self addSubview:_waitingView];
    
    __weak ItemImageView *imageViewWeak = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if ([_currentURL.absoluteString hasPrefix:@"http"]) {
            [_waitingView setHidden:NO];
        }else
            [_waitingView setHidden:YES];

        imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (_currentURL == imageURL) {
            if (image) {
                self.image = image;
                [self setNeedsLayout];
            }
        }
        [imageViewWeak removeWaitingView];
        
//        if (error) {
//            UILabel *label = [[UILabel alloc] init];
//            label.bounds = CGRectMake(0, 0, 160, 30);
//            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
//            label.text = @"图片加载失败";
//            label.font = [UIFont systemFontOfSize:16];
//            label.textColor = [UIColor whiteColor];
//            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
//            label.layer.cornerRadius = 5;
//            label.clipsToBounds = YES;
//            label.textAlignment = NSTextAlignmentCenter;
//            [imageViewWeak addSubview:label];
//        }
    }];
}

#pragma mark - zoom
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomingImageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    if (_zoomingScroolView.zoomScale != _zoomingScroolView.minimumZoomScale) {
        [self reviseContent:_zoomingImageView.frame.size :scrollView.contentSize :YES];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scal
{
    if (scrollView != _zoomingScroolView) {
        return;
    }
    if (scal == scrollView.minimumZoomScale) {
//        [self eliminateScale];
        return;
    }
    CGFloat containW = CGRectGetWidth(scrollView.frame);
    CGFloat containH = CGRectGetHeight(scrollView.frame);

    CGFloat contentW = CGRectGetWidth(_zoomingImageView.frame);
    CGFloat contentH = CGRectGetHeight(_zoomingImageView.frame);

    CGFloat imageW = _zoomingImageView.image.size.width;
    CGFloat imageH = _zoomingImageView.image.size.height;

    if (imageW == NAN || !imageW || imageW==0) {
        return;
    }
    if (imageH == NAN || !imageH || imageH==0) {
        return;
    }
    
    CGFloat imageDisW,imageDisH;

    CGFloat w ,h;

    CGFloat ratio = 1;
    if (imageW > imageH) {
        ratio = imageH/imageW;
        imageDisW = contentW;
        imageDisH = imageDisW*ratio;
        h = MAX(imageDisH, containH);
        w = scrollView.contentSize.width;
    }else if (imageW <= imageH) {
        ratio = imageW/imageH;
        imageDisH = contentH;
        imageDisW = imageDisH*ratio;
        h = scrollView.contentSize.height;
        w = MAX(imageDisW, containW);
    }

    _zoomingImageView.center = CGPointMake(w/2, h/2);

    [self reviseContent:_zoomingImageView.frame.size :CGSizeMake(w, h) :NO];
}

- (void)reviseContent:(CGSize)csize :(CGSize)displaySize :(BOOL)isStart
{
    CGPoint p =  _zoomingScroolView.contentOffset;
    
    _zoomingScroolView.contentSize = displaySize;
    CGFloat xRate = (csize.width-displaySize.width)/2;
    CGFloat yRate = (csize.height-displaySize.height)/2;
    int i = isStart?1:-1;
    p = CGPointMake(p.x+i*xRate, p.y+i*yRate);

    if (isStart) {
        _zoomingScroolView.contentSize = csize;
        _zoomingImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_zoomingImageView.frame), CGRectGetHeight(_zoomingImageView.frame));

    }

    _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (!isStart && _zoomingScroolView.zoomScale != _zoomingScroolView.minimumZoomScale) {
        CGFloat yDiff = _zoomingScroolView.contentSize.height-CGRectGetHeight(_zoomingScroolView.frame);
        CGFloat xDiff = _zoomingScroolView.contentSize.width-CGRectGetWidth(_zoomingScroolView.frame);
        if (p.y<0) {
            p.y = 0;
        }else if (p.y>yDiff) {
            p.y = yDiff;
        }
        if (p.x<0) {
            p.x = 0;
        }else if (p.x>xDiff) {
            p.x = xDiff;
        }
    }
    [_zoomingScroolView setContentOffset:p animated:NO];
    [self layoutSubviews];
}

- (void)initializationTouch
{
    if (!_zoomingScroolView) {
        _zoomingScroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScroolView.backgroundColor = ImageBrowserBackgrounColor;
        _zoomingScroolView.delegate = self;
        _zoomingScroolView.maximumZoomScale = 2;
        _zoomingScroolView.minimumZoomScale = 1;
        _zoomingScroolView.showsHorizontalScrollIndicator = NO;
        _zoomingScroolView.showsVerticalScrollIndicator = NO;

        _zoomingImageView = [[TapDetectingImageView alloc] initWithImage:self.image];
        _zoomingImageView.detectDelegate = self;
        _zoomingImageView.userInteractionEnabled = YES;
        
        _zoomingImageView.frame = _zoomingScroolView.bounds;
        _zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_zoomingScroolView addSubview:_zoomingImageView];
        [self addSubview:_zoomingScroolView];
        _zoomingScroolView.contentSize = _zoomingImageView.frame.size;
    }
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self eliminateScale];
    [self initializationTouch];
}

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer
{
    if (_waitingView.superview) {
        return;
    }
    _totalScale = 2.0;
    [self initializationTouch];
}

- (void)doubleToZoomRect:(CGPoint)touchPoint
{
    [self zoom:touchPoint];
}

- (void)zoom:(CGPoint)touchPoint
{
    [self initializationTouch];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if (_zoomingScroolView.zoomScale == _zoomingScroolView.maximumZoomScale) {
        [_zoomingScroolView setZoomScale:_zoomingScroolView.minimumZoomScale animated:YES];
    } else {
        CGSize s = _zoomingImageView.image.size;
        CGFloat y = touchPoint.y;
        CGFloat x = touchPoint.x;
        if (s.height > s.width) {
            x = CGRectGetMidX(_zoomingScroolView.frame);
        }else
            y = CGRectGetMidY(_zoomingScroolView.frame);
        [_zoomingScroolView zoomToRect:CGRectMake(x, y, 1, 1) animated:YES];
    }
}

// 清除缩放
- (void)eliminateScale
{
    [_zoomingImageView removeFromSuperview];
    [_zoomingScroolView removeFromSuperview];
    _zoomingScroolView = nil;
    _zoomingImageView = nil;
    _totalScale = 1.0;
    
    [_waitingView setHidden:YES];
}

- (void)removeWaitingView
{
    [_waitingView removeFromSuperview];
}

#pragma mark - touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(photoClick) withObject:nil afterDelay:0.5];
            break;
        case 2:
            [self doubleToZoomRect:[touch locationInView:_zoomingScroolView]];
        default:
            break;
    }
}

- (void)photoClick
{
    if ([_tapDelegate respondsToSelector:@selector(singleTap)]) {
        [_tapDelegate performSelector:@selector(singleTap)];
    }
}

#pragma mark - detecting delegate method
- (void)singleTap
{
    [self photoClick];
}
- (void)doubleTap:(NSValue *)touchPoint
{
    [self doubleToZoomRect:[touchPoint CGPointValue]];
}

@end
