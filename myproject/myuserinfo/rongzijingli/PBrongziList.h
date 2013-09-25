//
//  PBrongziList.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBtableViewEdit.h"
#import "PBinvestexperience.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBrongziList : PBtableViewEdit<PBdataClassDelegate>
{
    PBActivityIndicatorView *activity;
    PBdataClass *dataclass;
    int numsection;
}
@property(nonatomic,retain)NSMutableArray *arry;
@property(nonatomic,assign)int projectno;
@property(nonatomic,retain)PBinvestexperience *investorcase;
@end
