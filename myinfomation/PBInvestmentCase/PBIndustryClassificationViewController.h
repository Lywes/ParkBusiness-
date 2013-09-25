//
//  PBIndustryClassificationViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBIndustryData.h"
   

@interface PBIndustryClassificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate> {
    
    NSMutableArray      *nodesMutableArr;
    NSIndexPath *oldIndexpath;
    
  
    PBIndustryData *industryData;
    
    NSMutableArray *arr;
    
}
@property (nonatomic,retain) NSString *hangyeStr;
@property (nonatomic,retain) NSMutableDictionary *tradeArr;
@property (nonatomic,strong) PBParkManager *parkManager;
@property (nonatomic,retain) UITableView *tableView1;

- (void)tableViewInit;
- (void)refreshData;
@end
