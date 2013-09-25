//
//  PBAllManagerController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPullTableViewController.h"
#import "PBManager.h"

@interface PBAllManagerController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *manager;

@property (nonatomic, retain) NSString *fnoString;

@end
