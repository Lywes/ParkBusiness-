//
//  PBInvestorController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"
#import "PBPullTableViewController.h"

@interface PBInvestorController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) NSArray *investorArray;
@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *parseXMLManager;
@property (nonatomic, retain) PBSendData *send;
@end
