//
//  FASearchFriendController.h
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAChatManager.h"
#import "FAUserData.h"

@interface FASearchFriendController : UITableViewController<UISearchBarDelegate,FAChatManagerDelegate>{
    UISearchBar* searchBar_;
    NSMutableArray* dataSource_;
    UIButton *searchBtn;
}

@end
