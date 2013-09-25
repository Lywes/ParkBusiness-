//
//  PBCompanyChoose.h
//  ParkBusiness
//
//  Created by QDS on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBPullTableViewController.h"
#import "PBSettings.h"
@interface PBCompanyChoose : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PBWeiboDataDelegate, PBPullTableViewDelegete>{
    UISearchBar* searchBar;
    NSMutableArray* allData;
    PBPullTableViewController *pullController;
    PBWeiboDataConnect* companyData;
    NSIndexPath * oldint;
    void (^myblock)(void);
}
@property(nonatomic,retain)PBSettings* popController;
@property(nonatomic,retain)NSString* LoginOrSeting;//如果LoginOrSeting == login 代表登入时页面效果，否则 代表设置的页面效果，两个页面共用此类。
-(void)saveCompanyData:(NSMutableDictionary*)dic withImage:(UIImage*)image;
- (void) requestData:(NSString *)pageno;
@end
