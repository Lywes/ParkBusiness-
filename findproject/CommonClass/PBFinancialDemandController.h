//
//  PBFinancialDemandController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBFinancialDemandController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSDictionary *finacialDictionary;
@property (retain, nonatomic) IBOutlet UITableView *financialTabelView;

@end
