//
//  doTestViewController.m
//  doTest
//
//  Created by Doviceone on 15/4/23.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import "doTestViewController.h"

#import "doService.h"
#import "doApp.h"
#import "doPage.h"

#import "GroupModel.h"
#import "GroupCell.h"

@interface doTestViewController ()
{
    doModule *_model;
    ModelType _modelType;
    UITableView *_tableView;
    
    NSMutableArray *_titleArrays;
    
    UIView *_dicsView;
    // 回调对象
    DoEvenCallBack *_doEvenCallBack;
    // 所有model数据对象的合集
    GroupModel *_groupModel;
    // 标记当前的model数据对象
    NSObject *_methedObj;
}

@end

@implementation doTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor greenColor];
    
    if([self Init]) {
        [self configUI];
    }
    else {
        NSLog(@"初始化测试界面错误。创建model失败");
        NSLog(@"请将导入doExtLib文件夹下地.m文件添加到Targets:Do_Test下。Build Phases下的Source目录下。。因为直接添加的.m文件只会添加到doExtLib下");
    }
    // Do any additional setup after loading the view.
}

- (void)DisposeView {
    // 方法功能:销毁当前页面内所有组件。递归调用组件的[model Ondispose]
}

- (void)configUI
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    _dicsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w*2/3, h*2/3)];
    _dicsView.center = self.view.center;
    _dicsView.backgroundColor = [UIColor blackColor];
    _dicsView.alpha = 0;
    
    UITextField *title = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, w, h/10)];
    title.text = _groupModel.titles;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UIButton *dismiss = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismiss setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismiss setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    dismiss.backgroundColor = [UIColor clearColor];
    dismiss.frame = CGRectMake(0, 0, w/5, h/10);
    [dismiss addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, h/10, w, h/2) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 将视图view，添加到界面
    if(_modelType == UIModel) {
        doUIModule *uiModel = (doUIModule *)_model;
        UIView *view = (UIView *)uiModel.CurrentUIModuleView;
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(w/6, h*3/5, w*2/3, h*3/10);
        [self.view addSubview:view];
    }
    
    // 打印消息的View
    doLogEngine *log = (doLogEngine *)[doServiceContainer Instance].LogEngine;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, h*9/10, w, h/10) style:UITableViewStylePlain];
    log.printView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
}

- (void)dismissClick
{
    [self DisposeView];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"销毁");
    }];
}

- (BOOL)Init {
    [doService Init];
    NSString *testPath = [[NSBundle mainBundle] pathForResource:self.jsonName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:testPath];
    NSMutableDictionary *_testDics = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    _groupModel = [[GroupModel alloc] init];
    _groupModel.titles = [NSString stringWithFormat:@"ID:%@     Type:%@     Version:%@",[_testDics objectForKey:@"ID"],[_testDics objectForKey:@"Type"],[_testDics objectForKey:@"Version"]];
    
    _titleArrays = [NSMutableArray arrayWithArray:@[@"Properties",@"Events",@"syncMethodes",@"asyncMethodes"]];
    for (NSString *title in _titleArrays) {
        NSArray *array = [_testDics objectForKey:title];
        NSMutableArray *titleArray = [[NSMutableArray alloc] init];
        for (NSDictionary *d in array) {
            NSObject *obj = [[NSClassFromString([NSString stringWithFormat:@"%@Model",title]) alloc] init];
            [obj setValuesForKeysWithDictionary:d];
            [titleArray addObject:obj];
        }
        [_groupModel.allDics setObject:titleArray forKey:title];
    }
    
    if([[_testDics valueForKey:@"Type"] isEqualToString:@"UI"]) {
        doJsonNode *node = [[doJsonNode alloc] init];
        [node SetOneText:@"modelClassName" :[NSString stringWithFormat:@"%@_UIModel",[_testDics valueForKey:@"ID"]]];
        [node SetOneText:@"viewClassName" :[NSString stringWithFormat:@"%@_UIView",[_testDics valueForKey:@"ID"]]];
        
        doUIModule *model = [[doPage Instance] CreateUIModule:nil :node];
        _model = model;
        _modelType = UIModel;
    }
    else if ([[_testDics valueForKey:@"Type"] isEqualToString:@"SM"]) {
        doSingletonModule *model = [[doPage Instance] CreateSingletonModule:[NSString stringWithFormat:@"%@_SM",[_testDics valueForKey:@"ID"]]];
        _model = model;
        _modelType = SMModel;
    }
    else {
        doMultitonModule *model = [[doPage Instance] CreateMultitonModule:[NSString stringWithFormat:@"%@_MM",[_testDics valueForKey:@"ID"]]];
        _model = model;
        _modelType = MMModel;
    }
    if(_model) return YES;
    else return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrays = [_groupModel.allDics objectForKey:[_titleArrays objectAtIndex:section]];
    return arrays.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArrays.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titleArrays[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:_titleArrays[indexPath.section]];;
    NSArray *array = [_groupModel.allDics objectForKey:_titleArrays[indexPath.section]];
     NSObject *obj = array[indexPath.row];
    if(!cell) {
        cell = [[NSClassFromString([NSString stringWithFormat:@"%@Cell",_titleArrays[indexPath.section]]) alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];

        __weak typeof(self)weakSelf = self;
        cell.setDic = ^(NSString *methedName, BOOL isAsy, NSObject *model) {
            _methedObj = model;
            if(isAsy) _doEvenCallBack = [[DoEvenCallBack alloc] init];
            else _doEvenCallBack = nil;
            
            NSMutableArray *dicArr = [model valueForKey:@"Paras"];
            if(dicArr.count <= 0) {
                NSString *methedName = [model valueForKey:@"ID"];
                [self doMethed:nil methedName:methedName];
                return NO;
            }
            else {
                [weakSelf setDicView:dicArr];
                return YES;
            }
        };

        cell.event = ^(NSString *eventName, EventType eventType, NSObject *model) {
            if(eventType == EventOn) {
                // 异步方法订阅事件 <如果事件订阅成功。点击fire,DoEvenCallBack对象的方法将被执行>
                [doService asyncMethod:_model :@"on" :[NSMutableDictionary dictionaryWithObjectsAndKeys:eventName, @"name", nil] :[[DoEvenCallBack alloc] init]];
//                [doService subscribeEvent:_model :eventName :[[DoEvenCallBack alloc] init]];
            }
            else if (eventType == EventFire) {
                // 同步事件响应方法
                [doService syncMethod:_model :@"fire" :[NSMutableDictionary dictionaryWithObjectsAndKeys:eventName, @"name", nil]];
            }
            else {
                // 同步方法，取消事件
                [doService syncMethod:_model :@"off" :[NSMutableDictionary dictionaryWithObjectsAndKeys:eventName, @"name", nil]];
            }
        };
        cell.propertiesChanged = ^(NSString *name,NSString *type,NSString *value, NSObject *model) {
             // 所有的类型都将被认为是NSString类型
            [doService setPropertyValue:_model :name :value];
            [model setValue:value forKey:@"DefaultValue"];
        };
    }
    [cell setModel:obj];
    return cell;
}

- (void)setDicView:(NSMutableArray *)dic
{
    [_dicsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [UIView animateWithDuration:1 animations:^{
        _dicsView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.view addSubview:_dicsView];
    }];
    
    CGFloat h = _dicsView.frame.size.height/(dic.count+1);
    for (int i=0; i<dic.count; i++) {
        NSDictionary *d = dic[i];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, i*h, _dicsView.frame.size.width/2, h)];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = [UIColor redColor];
        name.backgroundColor = [UIColor yellowColor];
        name.text = [d objectForKey:@"ID"];
        name.tag = 1000+i;
        [_dicsView addSubview:name];
        
        UITextField *value = [[UITextField alloc] initWithFrame:CGRectMake(_dicsView.frame.size.width/2, i*h, _dicsView.frame.size.width/2, h)];
        value.tag = 2000+i;
        value.text = [d objectForKey:@"DefaultValue"];
        value.backgroundColor = [UIColor whiteColor];
        value.textColor = [UIColor blackColor];
        value.textAlignment = NSTextAlignmentLeft;
        if(i == 0) [value becomeFirstResponder];
        [_dicsView addSubview:value];
    }
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(0, dic.count*h, _dicsView.frame.size.width/2, h);
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(dicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_dicsView addSubview:cancel];
    
    UIButton *certain = [UIButton buttonWithType:UIButtonTypeCustom];
    [certain setTitle:@"确定" forState:UIControlStateNormal];
    certain.frame = CGRectMake(_dicsView.frame.size.width/2, dic.count*h, _dicsView.frame.size.width/2, h);
    [certain addTarget:self action:@selector(dicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_dicsView addSubview:certain];
}

- (void)doMethed:(NSMutableDictionary *)dic methedName:(NSString *)methedName{
    if(_doEvenCallBack) {
        [doService asyncMethod:_model :methedName :dic :_doEvenCallBack];
    }
    else
        [doService syncMethod:_model :methedName :dic];
}
- (void)dicBtn:(UIButton *)btn {
    NSMutableArray *Paras = [_methedObj valueForKey:@"Paras"];
    NSString *methedName = [_methedObj valueForKey:@"ID"];
    if([[btn currentTitle] isEqualToString:@"取消"]) {
        NSLog(@"取消");
    }
    else {
        NSMutableDictionary *dicViewDic = [[NSMutableDictionary alloc] init];
        for(int i=0; i<Paras.count; i++) {
            NSDictionary *d = Paras[i];
            UILabel *label = (UILabel *)[_dicsView viewWithTag:1000+i];
            
            UITextField *textField = (UITextField *)[_dicsView viewWithTag:2000+i];
            [d setValue:textField.text forKey:@"DefaultValue"];
            [dicViewDic setValue:textField.text forKey:label.text];
        }
        [self doMethed:dicViewDic methedName:methedName];
    }
    [UIView animateWithDuration:1 animations:^{
        _dicsView.alpha = 0;
    } completion:^(BOOL finished) {
        [_dicsView removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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

@implementation DoEvenCallBack

- (void)eventCallBack:(NSString *)_data
{
    [[doServiceContainer Instance].LogEngine WriteDebug:[NSString stringWithFormat:@"在%d行:异步方法回调:%@",__LINE__,_data]];
}
@end

