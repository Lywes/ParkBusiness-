//
//  PBAddLicaiInfo.h
//  ParkBusiness
//
//  Created by 上海 on 13-9-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddInsureInfo.h"
#import "POPView.h"
@interface PBAddLicaiInfo : PBAddInsureInfo<UIListViewDelegate>{
    UILabel *financename;
    UILabel* earor;
    UILabel* timeperiodLabel;
    UITextField* money;
    
    POPView *pop;
    NSMutableArray *timeperiod;
}

@end
