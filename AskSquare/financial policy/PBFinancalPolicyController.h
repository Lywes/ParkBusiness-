//
//  PBFinancalPolicyController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDropManage.h"
#import "PBWeiboDataConnect.h"
#import "PBCustomDropView.h"
#import "PBPullTableViewController.h"

@interface PBFinancalPolicyController : UIViewController<UITableViewDataSource, UITableViewDelegate, PBPullTableViewDelegete, DropDelegate, PBWeiboDataDelegate,UISearchBarDelegate>
{
    NSMutableArray *tradeImageName;
    NSArray *sortImageName;
    UIButton *tradebtn;
    UIButton *lastestbtn;
    NSMutableArray *financeArr;
    PBCustomDropView *tradeView;
    PBCustomDropView *lastestView;
    PBDropManage *dropDown1;
    PBDropManage *dropDown2;
    UISearchBar* searchBar;
}
@property (nonatomic, assign) int flag;
@property (nonatomic, retain) PBWeiboDataConnect *manager1;
@property (nonatomic, retain) PBWeiboDataConnect *manager2;
@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (retain, nonatomic) NSMutableArray *tradekinds;
@property (retain, nonatomic) NSMutableArray *sortkinds;
@property (nonatomic, readwrite, retain) NSString *instituteNo;
@property (nonatomic, readwrite, retain) NSString *sorttime;

@end

