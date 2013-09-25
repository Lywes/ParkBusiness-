//
//  PBtrend.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-9.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBtrendData.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBtrend : PBtableViewEdit<PBdataClassDelegate>
{
    PBActivityIndicatorView *activity;
}
@property(nonatomic,retain)PBtrendData *trends;
@property(nonatomic,assign)int projectno;
@property(nonatomic,retain)NSMutableDictionary *OtherData;
@end
