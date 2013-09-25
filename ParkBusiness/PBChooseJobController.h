//
//  PBChooseJobController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBChooseJobController : UITableViewController<PBWeiboDataDelegate>{
    PBActivityIndicatorView* indicator;
    NSArray* data;
    PBWeiboDataConnect* updateData;
    BOOL checked;
}
@property(nonatomic,readwrite)int rowno;
@end
