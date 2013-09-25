//
//  PBRemarkListController.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPullTableViewController.h"
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"

@interface PBRemarkListController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, PBPullTableViewDelegete, SuccessSendMessage>

@property (nonatomic, retain) PBPullTableViewController *pullController;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBSendData *sendmanager;
@property (nonatomic, retain) NSMutableDictionary *infoDic;
@property (nonatomic, retain) UIView *askView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *submitBtn;
//@property (nonatomic, retain) NSString *type;//问题的类型
//@property (nonatomic, retain) NSString *questionno;//问题编号

@end
