//
//  MyProject.h
//  ParkBusiness
//
//  Created by lywes lee on 13-2-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBuserinfo.h"
#import "PBprojectteam.h"
#import "PBbusinessmodel.h"
#import "PBprojectplan.h"
#import "PBrongzi.h"
#import "PBprojectTrends.h"
#import "PBrongziList.h"
#import "PBProjectData.h"
@class PBHomeController;

@interface MyProject : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     UITableView *tableview;
    NSMutableArray *projectinfos;
    PBHomeController *pbview;
    PBuserinfo * pb_xiangmuxinxi;
    PBprojectteam * pb_xiangmutuandui;
    PBbusinessmodel *pb_businessmodel;
    PBprojectplan *pb_projectplan;
    PBrongzi *pb_rongzi;
    PBprojectTrends *pb_trends;
    PBrongziList * pb_rongzilist;
    NSMutableDictionary *xiangmuinfos;
    NSMutableArray *keys;
    NSMutableArray *volue;
}
@property(nonatomic,retain)IBOutlet UITableView *tableview;
@property(nonatomic,retain)NSMutableArray *projectinfos;
@property(nonatomic,retain)PBProjectData *pbprojectdata;
@property(nonatomic,retain)NSString *ProjectStyle;//判断只读数据操作
@property(nonatomic,retain)NSMutableDictionary *dic;//判断只读数据操作的数据接口；
@end
