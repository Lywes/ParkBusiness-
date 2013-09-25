//
//  FAAcountManagementView.h
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-3.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAUserData.h"

@interface FAAcountManagementView : UITableViewController
{
    NSArray* item_;
    NSMutableArray* images_;
    NSDictionary* dataSource_;
    NSArray* key_;
    UITextField* textField;
    FAUserData *userdata;
}

@end
