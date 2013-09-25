//
//  PBFinancialCaseDetailController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "UIInputToolbar.h"
@interface PBFinancialCaseDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate,PBWeiboDataDelegate,UIActionSheetDelegate,UIInputToolbarDelegate>
{
    NSMutableArray *sectionAndRowDataArray;
    PBActivityIndicatorView* indicator;
    UIButton* shoucangbtn;
    UIInputToolbar* inputToolbar;
    PBWeiboDataConnect* sendmanager;
}

@property (retain, nonatomic) NSDictionary *dataDictionary;
@property (retain, nonatomic) NSString *caseno;
@property (retain, nonatomic) NSString *shoucang;
@property (retain, nonatomic) NSString *flag;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@end
