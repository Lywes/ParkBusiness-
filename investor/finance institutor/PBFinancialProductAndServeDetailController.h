//
//  PBFinancialProductAndServeDetailController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "PBdataClass.h"
#import "UIInputToolbar.h"
#import "UIImageView+CreditLevel.h"
@interface PBFinancialProductAndServeDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate,PBWeiboDataDelegate,PBdataClassDelegate,UIActionSheetDelegate,UIInputToolbarDelegate>
{
    NSArray *sectionAndRowDataArray;
    PBActivityIndicatorView* indicator;
    UIButton* shoucangbtn;
    UIInputToolbar* inputToolbar;
    PBWeiboDataConnect* sendmanager;
    NSString* inputtype;
    UIImageView* starImage;
}

@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@property(nonatomic,retain)NSString *no;
@end
