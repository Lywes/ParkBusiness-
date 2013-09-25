//
//  PBMyFinanceNeedsDetail.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBMyFinanceNeedsDetail : UIViewController<PBWeiboDataDelegate,UITableViewDelegate,UITableViewDataSource>{
    PBActivityIndicatorView* indicator;
    NSMutableArray* allData;
    UITableView* tableView;
    NSArray* titleArr;
    NSMutableArray* labelArr;
}
@property(nonatomic,retain)NSMutableDictionary* dicData;
@end
