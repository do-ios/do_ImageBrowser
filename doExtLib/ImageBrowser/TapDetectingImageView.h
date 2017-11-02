//
//  TapDetectingImageView.h
//  doDebuger
//
//  Created by wl on 15/7/11.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapDetectingDelegate <NSObject>
- (void)singleTap;
- (void)doubleTap:(NSValue *)touchPoint;
@end

@interface TapDetectingImageView : UIImageView
@property (nonatomic , weak) id<TapDetectingDelegate> detectDelegate;
@end
