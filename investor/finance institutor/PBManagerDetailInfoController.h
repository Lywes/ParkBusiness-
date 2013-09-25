//
//  PBManagerDetailInfoController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBSendData.h"
#import "CustomImageView.h"

@interface PBManagerDetailInfoController : UIViewController<UITableViewDataSource, UITableViewDelegate, SuccessSendMessage>
{
    NSArray *sectionAndRowDataArray;
}

@property (nonatomic, retain) PBSendData *sendManager;
@property (nonatomic, retain) NSDictionary *dataDictionary;

@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@end
