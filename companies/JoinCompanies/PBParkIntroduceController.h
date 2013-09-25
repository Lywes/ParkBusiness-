//
//  PBParkIntroduceController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBParkIntroduceController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (retain, nonatomic) IBOutlet UITableView *parkIntroduceTableView;
@end
