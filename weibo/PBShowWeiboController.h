//
//  PBShowWeiboController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDropDown.h"
#import "PBWeiboDataConnect.h"
#import "YIPopupTextView.h"
#import "PBCustomDropView.h"
#import "PBPullTableViewController.h"
@interface PBShowWeiboController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBWeiboDataDelegate,NIDropDownDelegate,YIPopupTextViewDelegate,PBPullTableViewDelegete>{
    PBPullTableViewController *pullController;
    PBDropDown *dropDown1;
    PBDropDown *dropDown2;
    PBWeiboDataConnect* weiboData1;
    PBWeiboDataConnect* weiboData2;
    UIButton* tradebtn;
    UIButton* lastestbtn;
    YIPopupTextView *popupTextView;
    PBCustomDropView* tradeView;
    PBCustomDropView* lastestView;
    BOOL btnPressed;
    NSArray* tradeImageName;
    NSArray* sortImageName;
}
@property (retain, nonatomic) NSMutableArray *tradekinds;
@property (retain, nonatomic) NSMutableArray *sortkinds;
@property(nonatomic,readwrite,retain)NSString* tutorflag;
@property(nonatomic,readwrite,retain)NSString* tradeNo;
@property(nonatomic,readwrite,retain)NSString* sortNo;
@end
