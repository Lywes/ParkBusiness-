//
//  PBFinanceNewsList.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBCustomDropView.h"
#import "PBPullTableViewController.h"
@interface PBFinanceNewsListView : UIViewController<UITableViewDataSource, UITableViewDelegate, PBPullTableViewDelegete, PBWeiboDataDelegate>
{
    NSMutableArray *tradeImageName;
    NSArray *sortImageName;
    NSMutableArray* financeArr;
}
@property (nonatomic, retain) PBWeiboDataConnect *manager1;
@property (nonatomic, retain) PBWeiboDataConnect *manager2;
@property (nonatomic, retain) PBPullTableViewController *pullController;

@end
