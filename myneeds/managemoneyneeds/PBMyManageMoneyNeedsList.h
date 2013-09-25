//
//  PBMyManageMoneyNeedsList.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "PBManageMoneyView.h"
@interface PBMyManageMoneyNeedsList : UIViewController<UITableViewDataSource,UITableViewDelegate,PBWeiboDataDelegate,PBManageMoneyDelegate>{
    PBManageMoneyView* titleView;
    UITableView* tableView;
    NSMutableArray* allData;
    PBActivityIndicatorView* indicator;
}

@property(nonatomic,retain)UIViewController* rootViewController;
@property(nonatomic,retain)NSMutableDictionary* needDic;
@end
