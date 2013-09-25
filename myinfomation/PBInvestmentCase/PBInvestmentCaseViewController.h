//
//  PBInvestmentCaseViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBInvestmentCaseDetailViewController.h"
#import "PBActivityIndicatorView.h"
#import "PBDetailAnLiData.h"

@interface PBInvestmentCaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate> {
    
    
    NSMutableArray      *nodesMutableArr;
    PBInvestmentCaseDetailViewController *detailVC;
    NSMutableArray *arry;
    PBDetailAnLiData *detail;
    NSMutableArray *detailArr;
    
}

@property (nonatomic,strong) PBParkManager *parkManager;
@property (nonatomic,retain) UITableView *tableView1;
- (void)tableViewInit;
- (void)rightBarButton;

@end
