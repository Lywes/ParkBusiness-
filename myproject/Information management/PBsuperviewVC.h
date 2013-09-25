//
//  PBsuperviewVC.h
//  ParkBusiness
//
//  Created by oh yes on 13-8-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBActivityIndicatorView.h"
#import "PBPublicTrainingVC.h"

@interface PBsuperviewVC : PBPublicTrainingVC
{
    PBActivityIndicatorView *activity;

}
@property(nonatomic,retain)UIView *topView;
@property(nonatomic,retain)NSMutableArray *_arr;

-(void)initTopViewNumBtn:(NSInteger)num BtnNameArr:(NSArray *)nameArr;
-(void)BtnImageChange:(id)sender;//与楼上方法配套使用
-(BOOL)TopViewHidden;
@end
