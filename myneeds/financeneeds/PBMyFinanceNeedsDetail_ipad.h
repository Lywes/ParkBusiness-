//
//  PBMyFinanceNeedsDetail_ipad.h
//  ParkBusiness
//
//  Created by 上海 on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
@interface PBMyFinanceNeedsDetail_ipad : UIViewController<UITableViewDataSource,UITableViewDelegate,PBWeiboDataDelegate>{
    UITableView* mainTableView;
    UITableView* subTableView;
    PBActivityIndicatorView* indicator;
    NSMutableArray* allData;
    NSArray* titleArr;
    NSMutableArray* labelArr;
    int indexno;
    UIButton* checkButton;
}
@property(nonatomic,retain)NSMutableDictionary* dicData;
@end
