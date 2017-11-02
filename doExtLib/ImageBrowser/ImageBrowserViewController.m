//
//  ImageBrowserViewController.m
//  doDebuger
//
//  Created by wl on 15/8/2.
//  Copyright (c) 2015年 deviceone. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "ImageBrowser.h"
#import "doInvokeResult.h"

@interface ImageBrowserViewController ()<ImageBrowserDelegate>
@property (nonatomic , strong) ImageBrowser *browser;
@end

@implementation ImageBrowserViewController
{
    NSArray *_pics;
    NSInteger _index;
    NSArray *_params;
}
@synthesize browser,browserSM;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [browser show:_pics :_index :_params];
    browser.frame = self.view.bounds;
    [self.view addSubview:browser];

}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (instancetype)init:(NSArray *)pics :(NSInteger)index :(NSArray *)params
{
    self = [super init];
    if (self) {
        browser = [ImageBrowser new];
        _pics = [NSArray array];
        _pics = pics;
        _index = index;
        _params = [NSArray array];
        _params = params;
        
        browser.delegate = self;

    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}

- (void)photoClick
{
    CATransition *transition = [CATransition new];
    transition.type = kCATransitionFade; //过度效果
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    transition.repeatCount = 1;
    transition.removedOnCompletion = YES;
    transition.duration = .3;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    });
    
    [self fireEvent];
}


//事件
- (void)fireEvent
{
    doInvokeResult *_invokeResult = [[doInvokeResult alloc] init:nil];
    NSDictionary *dict = @{@"index":[@(browser.currentImageIndex) stringValue]};
    [_invokeResult SetResultNode:dict];
    [browserSM.EventCenter FireEvent:@"result" :_invokeResult];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
