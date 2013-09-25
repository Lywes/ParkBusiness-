//
//  FACompanyInfoView.h
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-11-23.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPullTableViewController.h"
#import "PBWeiboDataConnect.h"
#import <CoreLocation/CoreLocation.h>
@interface FACompanyInfoView : UIViewController<PBPullTableViewDelegete,PBWeiboDataDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>
{
    PBPullTableViewController* pullController;
//    UITabBarController* rootController;
    PBWeiboDataConnect* weiboData;
    UIButton* investbtn;
    UIButton* companybtn;
    CLLocationManager *locationManager;
    BOOL canMove;
}
@property(nonatomic,retain)NSString* kind;
@property(nonatomic,retain)NSString* pageno;
@property(nonatomic,retain)UIViewController* parentController;
@end
