//
//  PBMyFinanceNeedsFeedBack.h
//  ParkBusiness
//
//  Created by 上海 on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBMyFinanceNeedsFeedBack : UITableViewController<PBWeiboDataDelegate>{
    PBActivityIndicatorView* indicator;
    NSMutableArray* allData;
    int indexno;
    UIButton* checkButton;
}
@property(nonatomic,retain)NSString* feedbackno;
@property(nonatomic,retain)NSString* type;
@end
