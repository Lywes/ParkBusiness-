//
//  PBTutorWeiboController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "UIInputToolbar.h"
#import "PBWeiboTitleView.h"
#import "YIPopupTextView.h"
#import "PBPullTableViewController.h"
@interface PBTutorWeiboController : UIViewController<UITableViewDataSource,UITableViewDelegate,PBWeiboDataDelegate,UIInputToolbarDelegate,YIPopupTextViewDelegate,PBPullTableViewDelegete>{
    PBPullTableViewController* pullController;
    PBWeiboDataConnect* weiboData;
    PBWeiboTitleView* titleView;
    YIPopupTextView *popupTextView;
    BOOL btnPressed;
}
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property(nonatomic,readwrite,retain)NSMutableDictionary* data;
@property(nonatomic,readwrite,retain)NSString* tcontentno;
@property(nonatomic,readwrite,retain)NSString* tutorflag;
@property(nonatomic,readwrite,retain)NSString* type;

@end
