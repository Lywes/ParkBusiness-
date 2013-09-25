//
//  FAGroupMemberController.h
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface FAGroupMemberController : UITableViewController<UIActionSheetDelegate,PBWeiboDataDelegate>{
    NSMutableArray *groupmember;
    PBWeiboDataConnect* memberData;
    PBActivityIndicatorView* indicator;
}
@property(nonatomic,readwrite) int groupid;
@end
