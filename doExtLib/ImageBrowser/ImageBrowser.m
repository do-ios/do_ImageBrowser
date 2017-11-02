//
//  ImageBrowser.m
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import "ImageBrowser.h"
#import "ItemImageView.h"
#import "ImageBrowserConfig.h"
#import "doIGlobal.h"
#import "doServiceContainer.h"
#import "doIApp.h"
#import "doISourceFS.h"
#import "doIDataFS.h"
#import "doIPage.h"
#import "doUIModuleHelper.h"
#import "doIOHelper.h"

#define SET_FRAME(CONTENTS) x = CONTENTS.frame.origin.x + increase;if(x < 0) x = pageWidth * 2+ImageBrowserImageViewMargin;if(x > pageWidth * 2+ImageBrowserImageViewMargin) x = ImageBrowserImageViewMargin;[CONTENTS setFrame:CGRectMake(x,CONTENTS.frame.origin.y,CONTENTS.frame.size.width,CONTENTS.frame.size.height)]

#define GET_KEYWINDOW [UIApplication sharedApplication].keyWindow;
#define MAX_VALUE [_imgs count]-1
#define MIN_VALUE 0

typedef NS_OPTIONS(NSUInteger, IMG_TYPE) {
    IMGS_HIGHQUALITY = 1,
    IMGS_PLACEHOLDER = 2,
};

typedef NS_OPTIONS(NSUInteger, IMG_URI_TYPE) {
    IMGS_NULL = 0,
    IMGS_DATA = 1,
    IMGS_HTTP = 2,
};

@interface ImageBrowser()<UIScrollViewDelegate,ItemImageViewDelegate>
@property (nonatomic, strong) id<doIScriptEngine> myScriptEngine;
@end

@implementation ImageBrowser
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    NSArray *_imgs;
    
    ItemImageView *_leftView;
    ItemImageView *_middleView;
    ItemImageView *_rightView;
    
    int lastPage;
    
    CGFloat _validatePage;
    
    UILabel *_labelIndex;
}
@synthesize myScriptEngine;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ImageBrowserBackgrounColor;
        _imgs = [[NSArray alloc] init];
        
        _validatePage = -1;
    }
    return self;
}

- (void)initialization{
    UIWindow *keyWindow = GET_KEYWINDOW;
    CGRect rect = self.bounds;
    rect.size.width += ImageBrowserImageViewMargin * 2;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
    _scrollView.frame = rect;
    _scrollView.center = CGPointMake(self.center.x, rect.size.height/2);
    
    _leftView = [[ItemImageView alloc] init];
    _leftView.tapDelegate = self;
    _middleView = [[ItemImageView alloc] init];
    _middleView.tapDelegate = self;
    _rightView = [[ItemImageView alloc] init];
    _rightView.tapDelegate = self;

    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - ImageBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    for (int j=0; j<3; j++) {
        CGFloat x = ImageBrowserImageViewMargin + j * (ImageBrowserImageViewMargin * 2 + w);
        CGRect r = CGRectMake(x, y, w, h);
        
        if (j == 0) _leftView.frame = r;
        if (j == 1) _middleView.frame = r;
        if (j == 2) _rightView.frame = r;
    }
    
    [_scrollView addSubview:_leftView];
    [_scrollView addSubview:_middleView];
    [_scrollView addSubview:_rightView];

    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*3, h)];

    lastPage = -1;
    
    _labelIndex = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 150, 100)];
    _labelIndex.center = CGPointMake(CGRectGetWidth(keyWindow.frame)/2, CGRectGetHeight(self.frame)-20-50);
    [_labelIndex setBackgroundColor:[UIColor clearColor]];
    [_labelIndex setTextColor:[UIColor whiteColor]];
    _labelIndex.textAlignment = NSTextAlignmentCenter;
    _labelIndex.font = [UIFont systemFontOfSize:20];
    [_labelIndex setText:[NSString stringWithFormat:@"%@/%@",@(_currentImageIndex+1),@(_imgs.count)]];
    _labelIndex.numberOfLines = 1;
    
    [self addSubview:_labelIndex];
}

#pragma mark -

#pragma mark UIScrollView cycle
- (void)allContentMoveRight:(CGFloat)pageWidth {
    ItemImageView *tmpView = _rightView;
    
    _rightView = _middleView;
    _middleView = _leftView;
    _leftView = tmpView;
    
    float increase = pageWidth;
    CGFloat x = 0.0f;
    
    SET_FRAME(_rightView);
    SET_FRAME(_leftView);
    SET_FRAME(_middleView);
}

- (void)allContentMoveLeft:(CGFloat)pageWidth {
    ItemImageView *tmpView = _leftView;
    
    _leftView = _middleView;
    _middleView = _rightView;
    _rightView = tmpView;
    
    float increase = -pageWidth;
    
    CGFloat x = 0.0f;
    
    SET_FRAME(_middleView);
    SET_FRAME(_rightView);
    SET_FRAME(_leftView);
}

#pragma mark - scrollview delegate method

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.frame.size.width;
    // 0 1 2
    if (_validatePage == -1) {
        _validatePage = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
}

- (void)eliminateScale
{
    NSArray *tmp = @[_leftView,_middleView,_rightView];
    [tmp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ItemImageView *imageView = (ItemImageView *)obj;
        [imageView eliminateScale];
        [imageView initializationTouch];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theself
{
    theself.userInteractionEnabled = YES;

    if (theself != _scrollView) {
        return;
    }
    if (_validatePage == -1) {
        return;
    }
    CGFloat pageWidth = theself.frame.size.width;
    
    // 0 1 2
    int page = floor((theself.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    if (_validatePage == page) {
        _validatePage = -1;
        return;
    }
    [self eliminateScale];
    _validatePage = -1;

    if (page > 2 || page < 0) {
        return;
    }
    
    BOOL isRight = (page>lastPage)?YES:NO;

    if (page == 1) {
        [self genetatePage:isRight];
    }

    lastPage = page;

    if (page == 0) {
        [self genetatePage:page];
        if (![self ifScroll:page]) {
            return;
        }
        [self allContentMoveRight:pageWidth];
    } else if (page == 2){
        [self genetatePage:page];
        if (![self ifScroll:page]) {
            return;
        }
        [self allContentMoveLeft:pageWidth];
    }
    
    if (page!=1) {
        [self newCreatePage:page];
    }

    CGPoint p = CGPointZero;
    
    p.x = pageWidth;
    
    [theself setContentOffset:p animated:NO];
}

- (void)genetatePage:(BOOL)isRight
{
    _currentImageIndex += isRight?1:-1;
    if (_currentImageIndex<MIN_VALUE) {
        _currentImageIndex = 0;
    }else if (_currentImageIndex>MAX_VALUE) {
        _currentImageIndex = MAX_VALUE;
    }
    
    [_labelIndex setText:[NSString stringWithFormat:@"%@/%@",@(_currentImageIndex+1),@(_imgs.count)]];
}


- (BOOL)ifScroll:(BOOL)ifLeft
{
    if ([_imgs count] < 3) {
        return false;
    }
    return [self pageNoLoopingValidate:ifLeft];
}

- (BOOL)pageNoLoopingValidate:(BOOL)ifLeft
{
    NSInteger pageIncrease = ifLeft?1:-1;
    NSInteger p = _currentImageIndex+pageIncrease;
    
    if (p < MIN_VALUE || p > MAX_VALUE) {
        return false;
    }
    return true;
}


- (void)resetView:(NSArray *)a
{
    for (int i = 0;i<a.count;i++) {
        int tmp = [[a objectAtIndex:i] intValue];
        if (i == 0) {
            [self getPage:tmp srcView:_leftView];
        }else if (i == 1){
            [self getPage:tmp srcView:_middleView];
        }else if(i == 2){
            [self getPage:tmp srcView:_rightView];
        }
    }
}

- (void)newCreatePage:(BOOL)ifRight
{
    NSInteger num = ifRight?1:-1;
    num += _currentImageIndex;
    if(ifRight){
        [self getPage:num srcView:_rightView];
    }else{
        [self getPage:num srcView:_leftView];
    }
}


#pragma mark - get img
- (void)getPage:(NSInteger)num srcView:(ItemImageView *)v
{
    if (num < MIN_VALUE || num > MAX_VALUE) {
        return;
    }
    ItemImageView *imageView = v;
    if ([self highQualityImageURLForIndex:num]) {
        [self loadImageindex:num image:imageView type:IMGS_PLACEHOLDER];
        [self loadImageindex:num image:imageView type:IMGS_HIGHQUALITY];
    } else {
        [self loadImageindex:num image:imageView type:IMGS_PLACEHOLDER];
    }
}

- (void)loadImageindex:(NSInteger)num image:(ItemImageView *)imageView type:(IMG_TYPE)type
{
    //得到图片地址字符串
    NSString *url = [self getImgUri:num imgType:type];

    //判断占位和高清是否要加载网络图片
    if (url && ![url isEqualToString:@""]) {
        if ([self getImgURIType:url] == IMGS_DATA) {
            //本地图片处理
            [self getLocalImage:num image:imageView imgType:type];
        }else if ([self getImgURIType:url] == IMGS_HTTP) {
            //网络图片处理
            [self getHTTPImage:num image:imageView imgType:type];
        }
    }
}

- (void)getLocalImage:(NSInteger)num image:(ItemImageView *)imageView imgType:(IMG_TYPE)type
{
    NSString *file = [self getImgUri:num imgType:type];

    NSString *fullPath = [doIOHelper GetLocalFileFullPath:self.myScriptEngine.CurrentApp :file];
    imageView.currentURL = [NSURL URLWithString:fullPath];
    [imageView setImage:[[UIImage alloc] initWithContentsOfFile:fullPath]];
}

- (void)getHTTPImage:(NSInteger)num image:(ItemImageView *)imageView imgType:(IMG_TYPE)type
{
    if (type == IMGS_HIGHQUALITY) {
        NSString *name = [self getImgUri:num imgType:IMGS_PLACEHOLDER];
        UIImage *placeImage = [[UIImage alloc] initWithContentsOfFile:name];
        [imageView setImageWithURL:[self highQualityImageURLForIndex:num] placeholderImage:placeImage];
    }else if (type == IMGS_PLACEHOLDER)
        [imageView setImageWithURL:[self placeholderImageForIndex:num] placeholderImage:[[UIImage alloc] init]];
}


- (IMG_URI_TYPE)getImgURIType:(NSString *)uri
{
    NSString *URI = [uri stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (URI.length<4) {
        return IMGS_NULL;
    }
    NSString *type = [URI lowercaseString];
    if ([type hasPrefix:@"data"] || [type hasPrefix:@"source"] || [type hasPrefix:@"initdata"]) {
        return IMGS_DATA;
    }else if ([type hasPrefix:@"http"]){
        return IMGS_HTTP;
    }else
        return IMGS_NULL;
}

- (NSString *)parseImgs:(IMG_TYPE)type imgsIndex:(NSInteger)index
{
    NSString *returnImg = @"";
    if (index<MIN_VALUE || index>MAX_VALUE) {
        return returnImg;
    }
    NSString *urlHighQuality = @"";
    NSString *urlPlaceHolder = @"";
    if ([[_imgs objectAtIndex:index]  isKindOfClass:[NSString class]]) {
        urlHighQuality = [_imgs objectAtIndex:index];
    }else{
        NSDictionary *urlDic = [_imgs objectAtIndex:index];
        urlHighQuality = [urlDic objectForKey:@"source"];
        urlPlaceHolder = [urlDic objectForKey:@"init"];
    }

    if(type==IMGS_HIGHQUALITY) return urlHighQuality;
    else return urlPlaceHolder;

    return returnImg;
}

- (NSURL *)placeholderImageForIndex:(NSInteger)index
{
    NSString *urlStr = [self parseImgs:IMGS_PLACEHOLDER imgsIndex:index];
    return [NSURL URLWithString:urlStr];
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self parseImgs:IMGS_HIGHQUALITY imgsIndex:index];
    return [NSURL URLWithString:urlStr];
}

- (NSString *)getImgUri:(NSInteger)index imgType:(IMG_TYPE)type
{
    return [self parseImgs:type imgsIndex:index];
}

#pragma mark - operate
- (void)didMoveToSuperview
{
    [self initialization];
    NSInteger c = _imgs.count>3?3:_imgs.count;
    NSMutableArray *a = [NSMutableArray array];
    if (_currentImageIndex == MIN_VALUE) {
        for (NSInteger i =0;i<c;i++) {
            [a addObject:@(i)];
        }
        _scrollView.contentOffset = CGPointMake(0, 0);
        lastPage = 0;
    }else if (_currentImageIndex == MAX_VALUE){
        for (NSInteger i = MAX_VALUE;i>=0;i--) {
            [a addObject:@(i)];
            if (a.count>=3) {
                break;
            }
        }
        a = [NSMutableArray arrayWithArray:[[a reverseObjectEnumerator] allObjects]];
        NSInteger page = (c==0)?c:c-1;
        _scrollView.contentOffset = CGPointMake(page * _scrollView.frame.size.width, 0);
        lastPage = 2;
    }else{
        a = [NSMutableArray arrayWithObjects: @(_currentImageIndex-1),@(_currentImageIndex),@(_currentImageIndex+1), nil];
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    }

    if (c<3) {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*c, _scrollView.frame.size.height)];
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*abs((int)_currentImageIndex), 0);
    }
    
    [self resetView:a];
}


- (void)show:(NSArray *)pics :(NSInteger)index :(NSArray *)params
{
    self.myScriptEngine = [params objectAtIndex:1];
    _currentImageIndex = index;

    _imgs = pics;
}

- (void)photoClick
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if ([_delegate respondsToSelector:@selector(photoClick)]) {
        [_delegate performSelector:@selector(photoClick)];
    }
}


#pragma mark - ItemImageViewDelegate
- (void)singleTap
{
    [self photoClick];
}


@end
