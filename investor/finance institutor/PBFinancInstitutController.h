//
//  PBFinancInstitutController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPullTableViewController.h"
#import "PBManager.h"

@interface PBFinancInstitutController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *manager;
@property (retain, nonatomic) UISearchBar *_searchBar;
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@end
