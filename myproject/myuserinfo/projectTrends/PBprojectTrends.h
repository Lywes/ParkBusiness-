//
//  PBprojectTrends.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBdataClass.h"
#import "PBtrend.h"
#import "PBTableViewModle.h"
#import "PBActivityIndicatorView.h"
@interface PBprojectTrends : PBTableViewModle<PBdataClassDelegate>
{
    PBtrend *pbtrend;
     PBActivityIndicatorView *activity;
    PBdataClass *dataclass;
    int numsection;
}
@property(nonatomic,retain)NSMutableArray *_trends;
@property(nonatomic,assign)int projectno;
@property(nonatomic,retain)NSString *ProjectStyle;
@property(nonatomic,retain)NSDictionary *OtherData;//(只读操作数据接口)
@end
