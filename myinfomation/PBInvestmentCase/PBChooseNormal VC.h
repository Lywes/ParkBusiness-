//
//  PBChooseNormal VC.h
//  ParkBusiness
//
//  Created by China on 13-8-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
@class PBFinancingCase;
@interface PBChooseNormal_VC : UITbavleViewControllerModel
{
     NSIndexPath *oldint;
    NSString *str;
    BOOL isSelect;
}
@property(nonatomic,assign)PBFinancingCase *financingcase;
@property(nonatomic,retain) NSIndexPath *indexpath;
-(void)KBMaster:(NSString *)key type:(NSString *)type;
@end
