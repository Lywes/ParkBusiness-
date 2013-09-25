//
//  PBRecommendProjectViewController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"
#import "PBPullTableViewController.h"
#import "PBDropDown.h"
#import "PBCustomDropView.h"
@interface PBRecommendProjectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, PBPullTableViewDelegete,NIDropDownDelegate>{
    PBDropDown *dropDown1;
    PBDropDown *dropDown2;
    PBCustomDropView* leftView;
    PBCustomDropView* rightView;
    UIButton* leftbtn;
    UIButton* rightbtn;
    BOOL btnPressed;
    NSMutableArray* leftImageName;
    NSMutableArray *typekinds;
    NSMutableArray *sortkinds;
    NSArray* sortImageName;
}

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBSendData *send;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSString *typeno;
@property (nonatomic, retain) NSString *sortno;
@end
