//
//  doWebView.h
//  DoBase
//
//  Created by Doviceone on 14/12/19.
//  Copyright (c) 2014年 Doviceone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doIUIModuleView.h"

#import "do_WebView_IView.h"
#import "do_WebView_Model.h"

@interface do_WebView_UIView : UIWebView <doIUIModuleView, UIWebViewDelegate,do_WebView_IView>
{
    @private
    __weak do_WebView_UIModel *model;
    id<doIScriptEngine> html_scriptEngine;
}
@end
