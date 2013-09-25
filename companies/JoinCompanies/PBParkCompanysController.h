//
//  PBParkCompanysController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDropDown.h"
#import "PBWeiboDataConnect.h"
#import "PBCustomDropView.h"
#import "PBPullTableViewController.h"

@interface PBParkCompanysController : UIViewController <UITableViewDataSource, UITableViewDelegate, PBPullTableViewDelegete, PBWeiboDataDelegate, NIDropDownDelegate>
{
    PBDropDown *dropDown1;
    PBDropDown *dropDown2;
    PBWeiboDataConnect *manage1;
    PBWeiboDataConnect *manage2;
    PBPullTableViewController *pullController;
    UIButton* tradebtn;
    UIButton* lastestbtn;
    PBCustomDropView* tradeView;
    PBCustomDropView* lastestView;
    NSMutableArray* tradeImageName;
    NSArray* sortImageName;
    NSString *tradeNo;
    NSString *sortNo;
}

@property (nonatomic, retain) NSString *parkNoString;
@property (nonatomic, retain) NSMutableArray *tradekinds;
@property (nonatomic, retain) NSMutableArray *sortkinds;

@end
