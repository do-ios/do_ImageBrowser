//
//  PropertiesCell.m
//  doTest
//
//  Created by Doviceone on 15/4/23.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import "PropertiesCell.h"

@implementation PropertiesCell
{
    NSObject *_model;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat w = frame.size.width;
        CGFloat h = frame.size.height;
        // 添加属性名label
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, h/5, w/5, h*3/5)];
        self.name.textColor = [UIColor whiteColor];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        
        // 添加属性类型label
        self.type = [[UILabel alloc] initWithFrame:CGRectMake(w/5, h/5, w/5, h*3/5)];
        self.type.textColor = [UIColor blackColor];
        self.type.backgroundColor = [UIColor clearColor];
        self.type.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.type];
        
        // 添加属性值输入框textField
        self.value = [[UITextField alloc] initWithFrame:CGRectMake(w*2/5, h/5, w*2/5, h*3/5)];
        self.value.placeholder = @"values";
        self.value.backgroundColor = [UIColor whiteColor];
        self.value.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.value];
        
        // 功能键button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w*4/5, h/5, w/5, h*3/5);
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:@"Chang" forState:UIControlStateNormal];
        btn.showsTouchWhenHighlighted = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(Chang:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        self.contentView.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)setModel:(NSObject *)model {
    _model = model;
    self.name.text = [model valueForKey:@"ID"];
    self.type.text = [model valueForKey:@"Type"];
    self.value.text = [model valueForKey:@"DefaultValue"];
}

- (void)Chang:(UIButton *)sender {
    self.propertiesChanged(self.name.text,self.type.text,self.value.text, _model);
//    [doService setPropertyValue:self.model :@"url" :@"http://www.baidu.com"];
}

@end
