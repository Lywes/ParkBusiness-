//
//  PBProjectDynamicController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBActivityIndicatorView.h"

@interface PBProjectDynamicController : UIViewController<ParseDataDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) NSString *noString;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) NSArray *dataArray;
@property (retain, nonatomic) IBOutlet UITableView *dynamicTableView;

@end
