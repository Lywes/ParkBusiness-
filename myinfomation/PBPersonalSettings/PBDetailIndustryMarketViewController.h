//
//  PBDetailIndustryMarketViewController.h
//  ParkBusiness
//
//  Created by  on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBInvestmentIndustryViewController.h"
#import "PBInvestmentSettingViewController.h"

@interface PBDetailIndustryMarketViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *detailIndustryArr;
    PBInvestmentIndustryViewController *iIVC;
    NSMutableString * strings;
}
@property (nonatomic,retain) NSMutableArray *arr;
@property (nonatomic,retain) UITableView *tableView1;
@property (nonatomic,retain) NSString *str;
@property (nonatomic,retain) NSMutableArray *strMutableArr;
@property (nonatomic,retain) NSMutableArray *indepatharry;
@property (nonatomic,assign)PBInvestmentSettingViewController* setting;
@end
