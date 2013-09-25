//
//  FAGroupListView.h
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAPush.h"
#import "FAChatManager.h"
#import "FAAddGroupView.h"
@interface FAGroupListView : UITableViewController<FAPushNotificationObserver,UISearchDisplayDelegate,UISearchBarDelegate,FAChatManagerDelegate,FAAddGroupViewDelegete>
{
    FAAddGroupView* addGroupView;
//    UIButton *addBtn;
    UISearchBar* searchBar;
    NSMutableArray *groupdata;
}
-(void)setAddGroupView;
@end
