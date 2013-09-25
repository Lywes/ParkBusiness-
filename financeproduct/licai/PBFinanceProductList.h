//
//  PBFinanceProductList.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBPullTableViewController.h"
@interface PBFinanceProductList : UIViewController<UITableViewDelegate,UITableViewDataSource,PBWeiboDataDelegate,PBPullTableViewDelegete>{
    PBPullTableViewController* pullController;
    PBWeiboDataConnect* weiboData;
    BOOL btnPressed;
    NSMutableDictionary* indexDic;
}
@property(nonatomic,readwrite,retain)NSString* recommend;
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@end
