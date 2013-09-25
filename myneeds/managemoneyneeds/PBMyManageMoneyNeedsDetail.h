//
//  PBMyManageMoneyNeedsDetail.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBMyManageMoneyNeedsDetail : UIViewController<PBWeiboDataDelegate,UITableViewDelegate,UITableViewDataSource>{
    PBActivityIndicatorView* indicator;
    NSArray* allData;
    UITableView* tableView;
    NSMutableArray* labelArr;
}
@property(nonatomic,retain)NSMutableDictionary* dicData;

@end
