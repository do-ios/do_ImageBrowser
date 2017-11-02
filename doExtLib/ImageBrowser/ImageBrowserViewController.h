//
//  ImageBrowserViewController.h
//  doDebuger
//
//  Created by wl on 15/8/2.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "do_ImageBrowser_SM.h"

@interface ImageBrowserViewController : UIViewController
@property (nonatomic , weak) do_ImageBrowser_SM *browserSM;

- (instancetype)init:(NSArray *)pics :(NSInteger)index :(NSArray *)params;
@end
