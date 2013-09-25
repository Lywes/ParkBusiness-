//
//  PBJoinBusinessUnionVC.h
//  ParkBusiness
//
//  Created by China on 13-9-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
#import "POPView.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBJoinBusinessUnionVC : UITbavleViewControllerModel<UIListViewDelegate,imageviewPickerdelegate,PBdataClassDelegate>
{
    PBActivityIndicatorView* indicator;
    POPView *pop;
    ImagePickerView *imagepickerview;
}
@end
