//
//  PBAllInvestorController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDropDown.h"
#import "PBWeiboDataConnect.h"
#import "PBCustomDropView.h"
#import "PBPullTableViewController.h"

@interface PBAllInvestorController : UIViewController<UITableViewDataSource, UITableViewDelegate, PBPullTableViewDelegete, NIDropDownDelegate, PBWeiboDataDelegate>
{
    NSMutableArray *tradeImageName;
    NSArray *sortImageName;
    UIButton *tradebtn;
    UIButton *lastestbtn;
    PBCustomDropView *tradeView;
    PBCustomDropView *lastestView;
    PBDropDown *dropDown1;
    PBDropDown *dropDown2;
}

@property (nonatomic, retain) PBWeiboDataConnect *manager1;
@property (nonatomic, retain) PBWeiboDataConnect *manager2;
@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (retain, nonatomic) NSMutableArray *tradekinds;
@property (retain, nonatomic) NSMutableArray *sortkinds;
@property (nonatomic, readwrite, retain) NSString *tradeNo;
@property (nonatomic, readwrite, retain) NSString *sortNo;

@end
