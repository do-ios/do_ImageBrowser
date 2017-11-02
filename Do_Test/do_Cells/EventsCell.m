//
//  EventsCell.m
//  doTest
//
//  Created by Doviceone on 15/4/23.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import "EventsCell.h"

@implementation EventsCell
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
        self.count = [[UILabel alloc] initWithFrame:CGRectMake(w/5, h/5, w/5, h*3/5)];
        self.count.textColor = [UIColor blackColor];
        self.count.text = @"0";
        self.count.backgroundColor = [UIColor clearColor];
        self.count.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.count];
        
        // 功能键button_On
        UIButton *on = [UIButton buttonWithType:UIButtonTypeCustom];
        on.showsTouchWhenHighlighted = YES;
        on.frame = CGRectMake(w*2/5, h/5, w/5, h*3/5);
        on.backgroundColor = [UIColor blackColor];
        [on setTitle:@"On" forState:UIControlStateNormal];
        [on setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [on addTarget:self action:@selector(On:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:on];
        
        // 功能button_Off
        UIButton *off = [UIButton buttonWithType:UIButtonTypeCustom];
        off.showsTouchWhenHighlighted= YES;
        off.frame = CGRectMake(w*3/5, h/5, w/5, h*3/5);
        off.backgroundColor = [UIColor blackColor];
        [off setTitle:@"Off" forState:UIControlStateNormal];
        [off setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [off addTarget:self action:@selector(Off:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:off];

        // 功能button_Fire
        UIButton *fire = [UIButton buttonWithType:UIButtonTypeCustom];
        fire.showsTouchWhenHighlighted = YES;
        fire.frame = CGRectMake(w*4/5, h/5, w/5, h*3/5);
        fire.backgroundColor = [UIColor blackColor];
        [fire setTitle:@"Fire" forState:UIControlStateNormal];
        [fire setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fire addTarget:self action:@selector(Fire:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:fire];
        
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setModel:(NSObject *)model {
    _model = model;
    self.name.text = [model valueForKey:@"ID"];
}

- (void)On:(UIButton *)sender {
    self.count.text = [NSString stringWithFormat:@"%d",[self.count.text intValue]+1];
    self.event(self.name.text, EventOn, _model);
}
- (void)Off:(UIButton *)sender {
    self.count.text = [NSString stringWithFormat:@"%d",[self.count.text intValue]-1<=0 ? 0 : [self.count.text intValue]-1];
    self.event(self.name.text, EventOff, _model);
}
- (void)Fire:(id)sender {
    self.event(self.name.text, EventFire, _model);
}

@end
