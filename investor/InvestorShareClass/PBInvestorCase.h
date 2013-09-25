//
//  PBInvestorCase.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

//投资案例列表
#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBInvestorCase : UIViewController <UITableViewDataSource, UITableViewDelegate, ParseDataDelegate>

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) NSString *allCaseInverstorNo;
@property (nonatomic, retain) NSArray *investorAllCaseArray;
@property (nonatomic, retain) PBManager *investorCaseManager;
@property (retain, nonatomic) IBOutlet UITableView *investorCaseTableView;

@end
