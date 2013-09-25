//
//  PBInvestmentIndustryViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBIndustryData.h"
@class PBInvestmentSettingViewController;

@interface PBInvestmentIndustryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PBParkManagerDelegate>
{
    
    NSMutableArray *nodesMutableArr;
    PBInvestmentSettingViewController *iSVC;
    PBIndustryData *industryData;
    
    NSMutableArray *arr;
    
    UINavigationBar *navigationBar;
    
}
@property (nonatomic,retain) NSMutableArray *strMutableArr;
@property (nonatomic,retain) NSMutableArray *indepatharry;
@property (nonatomic,retain) UITableView *tableView1;
@property (nonatomic,strong) PBParkManager *parkManager;
@property (nonatomic,retain)NSString *str;
@property (nonatomic,retain)NSString *noStr;
@property (nonatomic,retain)NSString *str1;
@property (nonatomic,retain)NSString *str2;
@property (nonatomic,retain)NSString *str3;
@property (nonatomic,assign)PBInvestmentSettingViewController* setting;


@end
