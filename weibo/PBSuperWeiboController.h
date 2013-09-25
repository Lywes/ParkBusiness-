//
//  PBSuperWeiboController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "YIPopupTextView.h"
#import "PBPullTableViewController.h"
#import "QuartzCore/QuartzCore.h"
@interface PBSuperWeiboController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBWeiboDataDelegate,YIPopupTextViewDelegate,PBPullTableViewDelegete>{
    PBPullTableViewController* pullController;
    PBWeiboDataConnect* weiboData;
    YIPopupTextView *popupTextView;
    BOOL btnPressed;
}
@property(nonatomic,readwrite,retain)NSString* tutorflag;

@end
