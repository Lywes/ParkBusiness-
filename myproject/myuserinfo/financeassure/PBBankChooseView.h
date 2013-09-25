//
//  PBBankChooseView.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBPullTableViewController.h"
#import "PBAddFinanceAssure.h"
@interface PBBankChooseView : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PBWeiboDataDelegate, PBPullTableViewDelegete>{
    UISearchBar* searchBar;
    NSMutableArray* allData;
    PBPullTableViewController *pullController;
    PBWeiboDataConnect* bankData;
}
@property(nonatomic,retain)PBAddFinanceAssure* popController;
@end
