//
//  PBJoinCompaniesController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBPullTableViewController.h"

@interface PBJoinCompaniesController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, assign) int flag;
@end
