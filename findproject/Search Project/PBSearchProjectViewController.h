//
//  PBSearchProjectViewController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBUserModel.h"
#import "PBSendData.h"
#import "PBPullTableViewController.h"

@interface PBSearchProjectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ParseDataDelegate, PBPullTableViewDelegete>{
}
@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBSendData *send;
@property (nonatomic, retain) NSArray *dataArray;
@property (retain, nonatomic) UISearchBar *searchSearchBar;
@end
