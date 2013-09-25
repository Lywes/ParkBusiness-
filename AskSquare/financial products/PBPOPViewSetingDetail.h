//
//  PBPOPViewSetingDetail.h
//  ParkBusiness
//
//  Created by China on 13-7-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
@class PBPOPViewSetting;
@interface PBPOPViewSetingDetail : UITbavleViewControllerModel
{
    NSIndexPath *oldint;
}
@property(nonatomic,assign)NSInteger replaceno;
@property(nonatomic,assign)PBPOPViewSetting *seting;
@end
