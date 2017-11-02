//
//  asyncMethodesCell.m
//  doTest
//
//  Created by Doviceone on 15/4/23.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import "asyncMethodesCell.h"

@implementation asyncMethodesCell
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
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(0, h/5, w/2, h*3/5)];
        self.name.textColor = [UIColor whiteColor];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        
        // 功能键button_dic
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(w/2, h/5, w/2, h*3/5);
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:@"添加字典" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(setDics:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        self.contentView.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)setModel:(NSObject *)model {
    _model = model;
    self.name.text = [model valueForKey:@"ID"];
}

- (void)setDics:(UIButton *)sender {
    if(self.setDic(self.name.text, YES, _model))
        [sender setTitle:@"修改字典" forState:UIControlStateNormal];
    else
        [sender setTitle:@"确定" forState:UIControlStateNormal];
}

@end
