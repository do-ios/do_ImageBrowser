//
//  PropertiesCell.h
//  doTest
//
//  Created by Doviceone on 15/4/23.
//  Copyright (c) 2015年 Doviceone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupCell.h"

@interface PropertiesCell : GroupCell

@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *type;
@property (strong, nonatomic) UITextField *value;

@end
