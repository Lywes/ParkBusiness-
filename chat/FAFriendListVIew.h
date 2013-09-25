//
//  FAFriendListView.h
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-7.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASearchFriendController.h"
#import "FAPush.h"
#import "CustomImageView.h"
@interface FAFriendListView : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,FAPushNotificationObserver>
{
    NSArray* item_;
    NSDictionary* dataSource_;
    NSArray* key_;
    NSMutableArray* images;
    UITabBarController* rootController;
    UIButton *addBtn;
    UISearchBar* searchBar;
}
@property(retain,nonatomic)IBOutlet UITableView* myTableView;
@property(strong,nonatomic)NSMutableDictionary* dataSourceDict;

@property(strong,nonatomic)NSMutableArray* dataSourceArry;
@property(retain,nonatomic)NSMutableArray* flagArray;

-(void)sectionHeaderClicked:(id)sender;
@end
