//
//  PBMyFInanceNeedsLIst.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBActivityIndicatorView.h"
#import "PBFinanceNeedsView.h"
#import "PBWeiboDataConnect.h"
@interface PBMyFinanceNeedsList : UIViewController<UITableViewDataSource,UITableViewDelegate,PBWeiboDataDelegate,PBFinanceNeedsDelegate,UIAlertViewDelegate>{
    NSMutableArray* allData;
    PBFinanceNeedsView* titleView;
    UITableView* tableView;
    PBActivityIndicatorView* indicator;
}
@property(nonatomic,retain)NSMutableDictionary* needDic;
@property(nonatomic,retain)UIViewController* rootViewController;
@end
