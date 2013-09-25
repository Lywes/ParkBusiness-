//
//  PBpersonerInfo.h
//  ParkBusiness
//
//  Created by China on 13-7-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
#import "POPView.h"
@interface PBpersonerInfo : UITbavleViewControllerModel<UIListViewDelegate>
{
    POPView *pop;
    UITextField *_name;
    UITextField *_companyname;
    UILabel * _hangye;
    UILabel * _xingbie;
}
@end
