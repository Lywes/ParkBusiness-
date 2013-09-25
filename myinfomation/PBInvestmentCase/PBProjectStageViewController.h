//
//  PBProjectStageViewController.h
//  ParkBusiness
//
//  Created by  on 13-4-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBProjectStageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *stageArr;
    NSIndexPath *oldIndexpath;
}


@property (nonatomic, retain) UITableView *tableView1;
@property (nonatomic, retain) NSString *str;
@end
