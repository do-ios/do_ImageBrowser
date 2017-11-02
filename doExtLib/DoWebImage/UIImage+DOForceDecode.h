//
//  UIImage+DoForceDecode.h
//  TestImageBrowser
//
//  Created by MingerW on 15/5/6.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOWebImageCompat.h"

@interface UIImage (DOForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image;

@end
