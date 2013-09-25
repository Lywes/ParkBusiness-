//
//  PBInvestorCaseDetail.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

//投资案例详细介绍
#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBInvestorCaseDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, ParseDataDelegate> {
//    NSArray *caseDetailSection;
    NSArray *caseDetailRow;
}

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) NSArray *caseDetailArray;
@property (nonatomic, retain) NSString *caseDetailProjectNoStr;
@property (nonatomic, retain) NSString *caseDetailProjectNameStr;
@property (nonatomic, retain) PBManager *caseDetailManager;
@property (retain, nonatomic) IBOutlet UITableView *caseDetailTableView;


@end
