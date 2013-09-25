//
//  PBReplyWeiboController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "UIInputToolbar.h"
#import "PBWeiboTitleView.h"
#import "PBPullTableViewController.h"

@interface PBReplyWeiboController : UIViewController<UITableViewDataSource,UITableViewDelegate,PBWeiboDataDelegate,UIInputToolbarDelegate,PBPullTableViewDelegete>{
    BOOL niceFlg;
    BOOL badFlg;
//    BOOL replyFlg;
    PBPullTableViewController* pullController;
    PBWeiboDataConnect* weiboData;
    PBWeiboTitleView* titleView;
}
@property(nonatomic,readwrite,retain)NSMutableDictionary* data;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@end
