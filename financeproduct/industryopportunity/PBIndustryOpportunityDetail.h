//
//  PBIndustryOpportunityDetail.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "UIInputToolbar.h"
#import "PBdataClass.h"

@interface PBIndustryOpportunityDetail : UITableViewController<PBWeiboDataDelegate,UIActionSheetDelegate,UIInputToolbarDelegate,PBdataClassDelegate>{
    PBActivityIndicatorView* indicator;
    UIButton* shoucangbtn;
    NSMutableArray* titleArr;
    BOOL myself;
    PBWeiboDataConnect* sendmanager;
    UIInputToolbar* inputToolbar;
}
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@property (retain, nonatomic) NSDictionary *dataDictionary;
@property (assign, nonatomic) BOOL searchDetail;
@property (retain, nonatomic) NSString *flag;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;

@end
