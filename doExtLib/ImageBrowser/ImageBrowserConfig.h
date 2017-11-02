//
//  ImageBrowserConfig.h
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ProgressViewModeLoopDiagram, // 环形
    ProgressViewModePieDiagram // 饼状
} ProgressViewMode;


// browser背景颜色
#define ImageBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define ImageBrowserImageViewMargin 10

// browser中显示图片动画时长
#define ImageBrowserShowImageAnimationDuration 0.8f

// browser中显示图片动画时长
#define ImageBrowserHideImageAnimationDuration 0.8f

// 图片下载进度指示进度显示样式（SDWaitingViewModeLoopDiagram 环形，SDWaitingViewModePieDiagram 饼型）
#define ProgressViewProgressMode ProgressViewModeLoopDiagram

// 图片下载进度指示器背景色
#define ProgressViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define ImageBrowserItemMargin 10