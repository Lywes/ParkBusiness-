//
//  PBFinancialProductAndServeController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPullTableViewController.h"
#import "PBManager.h"

@interface PBFinancialProductAndServeController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *manager;
@property (retain, nonatomic) UISearchBar *_searchBar;
//机构编号
@property (nonatomic, retain) NSString *fnoString;
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@end
