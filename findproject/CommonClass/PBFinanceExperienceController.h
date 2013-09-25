//
//  PBFinanceExperienceController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBFinanceExperienceController : UIViewController<ParseDataDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) NSString *projectNo;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) PBManager *manager;
@property (retain, nonatomic) IBOutlet UITableView *financeExperienceTableView;

@end
