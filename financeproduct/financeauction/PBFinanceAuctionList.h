//
//  PBFinanceAuctionList.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBPullTableViewController.h"
@interface PBFinanceAuctionList : UIViewController<UITableViewDelegate,UITableViewDataSource,PBWeiboDataDelegate,PBPullTableViewDelegete>{
    PBPullTableViewController* pullController;
    PBWeiboDataConnect* weiboData;
}
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@end
