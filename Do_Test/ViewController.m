//
//  ViewController.m
//  Do_Test
//
//  Created by linliyuan on 15/4/27.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "ViewController.h"
#import "doTestViewController.h"
#import "doPage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)configUI {
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    UIButton *example = [UIButton buttonWithType:UIButtonTypeCustom];
    example.frame = CGRectMake(w/3, h/5, w/3, h/5);
    [example setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    example.backgroundColor = [UIColor blueColor];
    [example setTitle:@"WebView_UI" forState:UIControlStateNormal];
    [example addTarget:self action:@selector(deviceOne:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:example];
    
    UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
    test.frame = CGRectMake(w/3, h/2, w/3, h/5);
    [test setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    test.backgroundColor = [UIColor greenColor];
    [test setTitle:@"Test" forState:UIControlStateNormal];
    [test addTarget:self action:@selector(deviceOne:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
}

- (void)deviceOne:(UIButton *)sender
{
    doTestViewController *testController = [[doTestViewController alloc] init];
    if([[sender currentTitle] isEqualToString:@"Test"]) {
        testController.jsonName = @"do_Test";
    }
    else {
        testController.jsonName = @"do_WebView";
    }
    [self presentViewController:testController animated:YES
                     completion:^{
                         [doPage Instance].PageView = testController;
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
