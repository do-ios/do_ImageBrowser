//
//  TYPEID_UI.h
//  DoExt_UI
//
//  Created by Doviceone on @time.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol do_WebView_IView <NSObject>

@required
//属性方法
- (void)change_url:(NSString *)newValue;
- (void)change_headerView:(NSString *)newValue;

- (void)loadString :(NSArray *)_parms;
- (void)back :(NSArray *)_parms;
- (void)forward :(NSArray *)_parms;
- (void)reload :(NSArray *)_parms;
- (void)stop :(NSArray *)_parms;
- (void)canForward :(NSArray *)_parms;
- (void)canBack :(NSArray *)_parms;
- (void)rebound:(NSArray *)parms;

@end
