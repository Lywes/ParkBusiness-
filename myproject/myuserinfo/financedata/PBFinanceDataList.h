//
//  PBFinanceDataList.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBFinanceAccountData.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBFinanceDataList : UITableViewController<PBdataClassDelegate>{
    NSMutableArray* dataList;
    PBActivityIndicatorView*activity;
}
@property(nonatomic,retain)NSDictionary* userinfo;
@property(nonatomic,retain)NSString* ProjectStyle;
@property(nonatomic,assign)int projectno;
@property(nonatomic,assign)int productno;
@property(nonatomic,assign) int count;
@property(nonatomic,retain) NSString* mode;
@end
