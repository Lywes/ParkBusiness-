//
//  PBFinancingVC.h
//  ParkBusiness
//
//  Created by QDS on 13-6-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"

@interface PBFinancingVC : UITbavleViewControllerModel<PBdataClassDelegate>
@property(nonatomic,retain)NSMutableArray *textview_arr;
@property(nonatomic,retain)PBActivityIndicatorView *actity;
@end
