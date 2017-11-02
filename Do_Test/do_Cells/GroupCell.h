//
//  GroupCell.h
//  doTest
//
//  Created by linliyuan on 15/4/24.
//  Copyright (c) 2015年 MingerW. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EventType) {
    EventOn,
    EventOff,
    EventFire
};

typedef BOOL(^SetDic)(NSString *methedName, BOOL isAsy, NSObject *model);

typedef void(^PropertiesChanged)(NSString *name,NSString *type,NSString *value, NSObject *model);
typedef void(^Event)(NSString *eventName, EventType eventType, NSObject *model);


@interface GroupCell : UITableViewCell

- (void)setModel:(NSObject *)model;

@property(nonatomic, copy)SetDic setDic;
@property(nonatomic, copy)Event event;
@property(nonatomic, copy)PropertiesChanged propertiesChanged;

@end
