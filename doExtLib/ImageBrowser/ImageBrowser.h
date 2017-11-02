//
//  ImageBrowser.h
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageBrowserDelegate <NSObject>
- (void)photoClick;
@end

@interface ImageBrowser : UIView

@property (nonatomic, weak) id<ImageBrowserDelegate> delegate;
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;

- (void)show:(NSArray *)pics :(NSInteger)index :(NSArray *)params;


@end
