//
//  PBSpecificSectoralCompaniesController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"
#import "PBPullTableViewController.h"

@interface PBSpecificSectoralCompaniesController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *tradeID;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBSendData *send;
@end
