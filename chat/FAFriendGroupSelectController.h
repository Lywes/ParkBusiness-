//
//  FAFriendGroupSelectController.h
//  FASystemDemo
//
//  Created by wangzhigang on 13-4-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAAddGroupView.h"
@interface FAFriendGroupSelectController : UITableViewController<FAAddGroupViewDelegete>{
    NSMutableArray *allFriendGroup;
    NSMutableArray *checkGroupArr;
    FAAddGroupView* addGroupView;
}
@property(nonatomic,readwrite)int no;
@end
