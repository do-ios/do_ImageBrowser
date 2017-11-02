//
//  do_ImageBrowser_IMethod.h
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol do_ImageBrowser_ISM <NSObject>

@required
//实现同步或异步方法，parms中包含了所需用的属性
- (void)show:(NSArray *)parms;

@end