//
//  PBSpecificTradeController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"
#import "PBPullTableViewController.h"

@interface PBSpecificTradeController : UIViewController<UITableViewDataSource, UITableViewDelegate,ParseDataDelegate, PBPullTableViewDelegete>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) NSString *tradeString;
@property (nonatomic, retain) NSString *tradeTitleString;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBSendData *send;
@property (nonatomic, retain) NSArray *dataArray;
@end
