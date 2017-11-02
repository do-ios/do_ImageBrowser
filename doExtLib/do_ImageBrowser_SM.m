//
//  do_ImageBrowser_SM.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_ImageBrowser_SM.h"

#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doIApp.h"
#import "doIDataFS.h"
#import "doIOHelper.h"
#import "doJsonHelper.h"
#import "doIScriptEngine.h"
#import "doIPage.h"

#import "ImageBrowserViewController.h"

#import "DoWebImage/DOWebImageManager.h"
#import "DOImageCache.h"

#define DEFAULT_INDEX 0

@interface do_ImageBrowser_SM()
@property (nonatomic, strong)id<doIScriptEngine> myScritEngine;
@end

@implementation do_ImageBrowser_SM
#pragma mark -
#pragma mark - 同步异步方法的实现
/*
 1.参数节点
     doJsonNode *_dictParas = [parms objectAtIndex:0];
     a.在节点中，获取对应的参数
     NSString *title = [_dictParas GetOneText:@"title" :@"" ];
     说明：第一个参数为对象名，第二为默认值
 
 2.脚本运行时的引擎
     id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
 
 同步：
 3.同步回调对象(有回调需要添加如下代码)
     doInvokeResult *_invokeResult = [parms objectAtIndex:2];
     回调信息
     如：（回调一个字符串信息）
     [_invokeResult SetResultText:((doUIModule *)_model).UniqueKey];
 异步：
 3.获取回调函数名(异步方法都有回调)
     NSString *_callbackName = [parms objectAtIndex:2];
     在合适的地方进行下面的代码，完成回调
     新建一个回调对象
     doInvokeResult *_invokeResult = [[doInvokeResult alloc] init];
     填入对应的信息
     如：（回调一个字符串）
     [_invokeResult SetResultText: @"异步方法完成"];
     [_scritEngine Callback:_callbackName :_invokeResult];
 */
//同步
 - (void)show:(NSArray *)params
 {
     
     NSArray *imgs = [doJsonHelper GetOneArray:[params objectAtIndex:0] :@"data"];
     //自己的代码实现

     NSInteger index = [doJsonHelper GetOneInteger:[params objectAtIndex:0] :@"index" :0];

     if (!imgs) {
         [NSException raise:self.description format:@"数据格式不正确（应该为图片地址的数组）",nil];
         return;
     }

     self.myScritEngine = [params objectAtIndex:1];
     NSString *fileFullName = [self.myScritEngine CurrentApp].DataFS.RootPath;
     [DOImageCache cacheNameSpace:fileFullName];
     
     //清除存储器缓存
//     [[DOWebImageManager sharedManager].imageCache clearDisk];
//     [[DOWebImageManager sharedManager].imageCache clearMemory];
     
     ImageBrowserViewController *vc = [[ImageBrowserViewController alloc] init:imgs :index :params];
     vc.view.backgroundColor = [UIColor blackColor];
     vc.browserSM = self;
     UIViewController *currentVC =(UIViewController*)self.myScritEngine.CurrentPage.PageView;
     [currentVC.navigationController pushViewController:vc animated:NO];
}
//异步
@end