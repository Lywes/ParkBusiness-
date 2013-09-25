//
//  PBprojectplan.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBdataClass.h"
#import "PBaddprojectplan.h"
#import "PBActivityIndicatorView.h"
@interface PBprojectplan : PBtableViewEdit<PBdataClassDelegate>
{
    NSMutableArray *arry_lables;
    
    PBActivityIndicatorView *activity;
    PBaddprojectplan *pbaddprojectpaln;
    PBdataClass *dataclass;
    int numsection;
}
@property(nonatomic,retain)    NSMutableArray *arry_lables;
@property(nonatomic,retain)NSMutableArray * celltext;//页面数据(可读写数据接口)
@property(nonatomic,assign)int projectno;
@end
