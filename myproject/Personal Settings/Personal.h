//
//  Personal.h
//  ParkBusiness
//
//  Created by lywes lee on 13-2-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBdataClass.h"
#import "PBSettings.h"
#import "PBHelpView.h"
#import "PBfankui.h"
@interface Personal : UIViewController<UITableViewDataSource,UITableViewDelegate,PBdataClassDelegate>
{
    UITableView *_tableview;
    NSMutableArray *_dataarry;
    NSMutableArray *_switcharry;
    PBSettings *setting;
     PBHelpView *helpview;
    PBfankui*pbfankui;
    int flagno;
    NSString *flagname;
}
@property(nonatomic,retain)NSMutableArray *_datas;
@property(nonatomic,retain)NSString *flag;
@end
