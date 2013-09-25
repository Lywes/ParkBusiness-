//
//  PBAuctionProcess.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBAuctionProcess : UITableViewController<PBWeiboDataDelegate>{
    PBActivityIndicatorView* indicator;
    NSMutableArray* allData;
}
@property(nonatomic,retain)NSString* no;
@end
