//
//  PBDetailBusinessPlanViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"

@interface PBDetailBusinessPlanViewController : UIViewController<PBParkManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray      *nodesMutableArr;
    
}
@property (nonatomic,retain) PBParkManager *parkManager;
@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@end
