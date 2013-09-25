//
//  PBProjectCatedoryViewController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBProjectCatedoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate>

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) NSArray *dataArray;
@property (retain, nonatomic) IBOutlet UITableView *tradekindTabelView;

@end
