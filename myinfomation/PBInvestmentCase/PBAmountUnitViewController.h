//
//  PBAmountUnitViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBInvestmentCaseDetailViewController;
@class PBAddCaseViewController;

@interface PBAmountUnitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
        // NSMutableArray      *nodesMutableArr;
    NSIndexPath *oldIndexpath;
    NSMutableArray *unitArr;
    PBInvestmentCaseDetailViewController *icdVC;
    PBAddCaseViewController              *acVC;
    
    
}
@property (nonatomic,assign) PBAddCaseViewController              *acVC;
@property (nonatomic,assign) PBInvestmentCaseDetailViewController *icdVC;
@property (nonatomic,retain) UITableView *tableView1;
@property (nonatomic,retain) NSString *str;
- (void)tableViewInit;



@end
