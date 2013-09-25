//
//  PBMyNeedsSelectView.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBMyNeedsSelectView : UITableViewController<PBWeiboDataDelegate>{
    NSMutableArray *allData;
    NSMutableArray *checkArr;
    PBActivityIndicatorView* indicator;
    
}
@property(nonatomic,retain)NSMutableDictionary* dic;
@property(nonatomic,retain)NSString* type;
@end
