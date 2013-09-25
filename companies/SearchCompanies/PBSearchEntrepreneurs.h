//
//  PBSearchEntrepreneurs.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"
#import "PBPullTableViewController.h"


@interface PBSearchEntrepreneurs : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBSendData *send;
@property (retain, nonatomic) UISearchBar *searchSearchbar;
@end
