//
//  FAGroupSelectController.h
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAChatManager.h"

@interface FAGroupSelectController : UITableViewController{
    NSMutableArray *groupdata;
}
@property(nonatomic,readwrite) int friendid;
@end
