//
//  PBinvestexperience.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "POPView.h"
#import "PBrongzijingliData.h"
#import "PBdataClass.h"
#import "PBUserModel.h"
#import "PBActivityIndicatorView.h"
@interface PBinvestexperience : PBtableViewEdit<UIListViewDelegate,PBdataClassDelegate>
{
    NSMutableArray *textfieldarry;
    NSMutableArray *lablearry;
    UILabel *_stage;
    UILabel *_unit;
    UITextField *_anmout;
     UITextField *_stadate;
    UITextField *_touziren;
    PBActivityIndicatorView *activity;

}
@property(nonatomic,retain)NSMutableArray *namearry;
@property(nonatomic,retain)NSMutableArray *stage;
@property(nonatomic,retain)NSMutableArray *unit;
@property(nonatomic,retain)POPView *stageview;
@property(nonatomic,retain)POPView *unitview;
@property(nonatomic,retain)PBrongzijingliData*data;
@property(nonatomic,assign)int projectno;
@end
