//
//  PBInvestorDetail.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

//该投资的详细介绍
#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBUserModel.h"
#import "PBActivityIndicatorView.h"

@interface PBInvestorDetail : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, SuccessSendMessage, UIActionSheetDelegate>
{
    NSArray *datarow_;
}

@property (nonatomic, retain) NSArray *projectInfoArray;
@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) PBSendData *sendManager;
@property (nonatomic, retain) NSString *investorNo;
@property (nonatomic, retain) PBManager *XMLInvestorDetailManager;
@property (nonatomic, retain) NSDictionary *investorDetailData;
@property (retain, nonatomic) IBOutlet UITableView *investorDetailTableView;

@end
