//
//  PBFinancingCase.h
//  ParkBusiness
//
//  Created by China on 13-8-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
/*
 数据源为 self.DataArr;
 */
#import "UITbavleViewControllerModel.h"
#import "PBActivityIndicatorView.h"
@interface PBFinancingCase : UITbavleViewControllerModel
{
    UITextField *name_textfield;
    PBActivityIndicatorView *activity;
}
@property(nonatomic,assign)NSInteger productno;
@property(nonatomic,retain)NSString * Mod_Add;
@property(nonatomic,assign)NSInteger  projectno;
@end
