//
//  PBIndustryOpportunityList.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBCustomDropView.h"
#import "PBPullTableViewController.h"
#import "PBDropManage.h"
#import "PBdataClass.h"
@interface PBIndustryOpportunityList : UIViewController<UITableViewDataSource, UITableViewDelegate, PBPullTableViewDelegete, DropDelegate, PBWeiboDataDelegate,PBdataClassDelegate,UISearchBarDelegate>
{
    UISearchBar*searchBar;
    NSMutableArray *tradeImageName;
    NSMutableArray *sortImageName;
    UIButton *tradebtn;
    UIButton *typebtn;
    PBCustomDropView *tradeView;
    PBCustomDropView *lastestView;
    PBDropManage *dropDown1;
    PBDropManage *dropDown2;
}
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (retain, nonatomic) NSMutableArray *tradekinds;
@property (retain, nonatomic) NSMutableArray *typekinds;
@property (nonatomic, readwrite, retain) NSString *trade;
@property (nonatomic, readwrite, retain) NSString *type;



@end
