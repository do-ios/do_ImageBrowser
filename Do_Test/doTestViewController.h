//
//  doTestViewController.h
//  doTest
//
//  Created by Doviceone on 15/4/23.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "doIPageView.h"
#import "doIPage.h"
#import "doIEventCallBack.h"

// 添加自定义头文件

typedef NS_ENUM(NSInteger, ModelType) {
    UIModel,
    SMModel,
    MMModel
};

@interface doTestViewController : UIViewController<doIPageView,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy)NSString *jsonName;
@property (nonatomic, readonly,strong) id<doIPage> PageModel;
@property (nonatomic, strong) NSString* CustomScriptType;
- (void) DisposeView;

@end


// 实现事件发送的类
@interface DoEvenCallBack : NSObject<doIEventCallBack>

@end

