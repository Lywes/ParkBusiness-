//
//  PBSuccessprojectList.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
#import "PBdataClass.h"
@interface PBSuccessprojectList : UITbavleViewControllerModel<PBdataClassDelegate>
{
    PBdataClass *dataclass;
}
@end
