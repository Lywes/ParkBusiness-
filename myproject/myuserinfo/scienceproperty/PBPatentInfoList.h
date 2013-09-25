//
//  PBPatentInfoList.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBActivityIndicatorView.h"
#import "PBdataClass.h"
@interface PBPatentInfoList : UITableViewController<PBdataClassDelegate>{
    NSMutableArray* dataList;
    NSInteger numbersection;
    PBActivityIndicatorView *activity;
    PBdataClass *pbdataclass;
}
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)NSString *ProjectStyle;
@property(nonatomic,assign)int projectno;
@end
