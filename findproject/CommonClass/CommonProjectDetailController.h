//
//  CommonProjectDetailController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBManager.h"
#import "PBSendData.h"
#import "PBActivityIndicatorView.h"
#import "PBUserModel.h"

@interface CommonProjectDetailController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParseDataDelegate, SuccessSendMessage>{
    NSMutableArray* titleArr;
}

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (nonatomic, retain) UIButton *collectButton;
@property (nonatomic, retain) PBSendData *collectData;
@property (nonatomic, retain) NSString *caseNo;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) PBManager *manager;
@property (nonatomic, retain) PBManager *favouritesManager;
@property (nonatomic, retain) NSArray *favouritesInfoListArray;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;

@end
