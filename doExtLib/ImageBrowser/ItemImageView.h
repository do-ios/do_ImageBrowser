//
//  ItemImageView.h
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemImageViewDelegate <NSObject>
- (void)singleTap;
@end

@interface ItemImageView : UIImageView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;
@property (nonatomic, strong) NSURL *currentURL;

@property (nonatomic,weak) id<ItemImageViewDelegate> tapDelegate;

- (void)eliminateScale; // 清除缩放
- (void)initializationTouch;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
