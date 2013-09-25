//
//  PBhuodongyugaoVC.h
//  PBBank
//
//  Created by lywes lee on 13-5-6.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBDropDown.h"
#import "PBRefreshTableHeaderView.h"
#import "PBPullTableViewController.h"
#import "PBdataClass.h"
@interface PBhuodongyugaoVC : UIViewController<NIDropDownDelegate,UITableViewDelegate,UITableViewDataSource,PBPullTableViewDelegete,PBdataClassDelegate>
{
    UIImageView *fangxiang1;
     UIImageView *fangxiang2;
    PBDropDown *dropview1;
    PBDropDown *dropview2;
    
    PBPullTableViewController *pulltableview;
    PBRefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;//主要是记录是否在刷新中
    PBdataClass *dataclass;
    NSInteger pageno;
}
@property(nonatomic,retain)NSMutableArray *DataArr;//数据接口
@property(nonatomic,retain)NSString *stylename;
@end
