//
//  PBsixin.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsuperviewVC.h"
@interface PBsixin : PBsuperviewVC{
    float Tag;
    NSArray * sixin_arry;
    
    //网络请求
    PBdataClass *inbox;
    PBdataClass *outbox;
    UIView *topView;
    BOOL isselect;
    BOOL wantChange;
}
@property(nonatomic,retain)NSMutableArray *dataOfSixin;
@property(nonatomic,retain)NSMutableArray * sixin_dis;
@property(nonatomic,retain)NSMutableArray * sixin_did;
@property(nonatomic,retain)NSMutableArray * sixin_didpost;
@property(nonatomic,retain)NSMutableArray * _arry;
-(void)toGetTheData;
-(void)changeFlageOfMessageatIndePath:(NSIndexPath *)indexpath;
@end
