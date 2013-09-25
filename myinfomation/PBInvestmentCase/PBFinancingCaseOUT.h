//
//  PBFinancingCaseOUT.h
//  ParkBusiness
//
//  Created by China on 13-8-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
@class PBFinancingCase;
@interface PBFinancingCaseOUT : UITbavleViewControllerModel
@property(nonatomic,assign)PBFinancingCase *financingcase;
@property(nonatomic,retain)UITextView *textview;
@property(nonatomic,retain)NSString *ClassTitle;
@property(nonatomic,retain) NSIndexPath *indexpath;
@end
