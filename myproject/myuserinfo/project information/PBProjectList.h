//
//  PBProjectList.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBProjectData.h"
#import "MyProject.h"
#import "FAAddGroupView.h"
#import "PBdataClass.h"
#import "PBUserModel.h"
@interface PBProjectList : UITableViewController<FAAddGroupViewDelegete,PBdataClassDelegate>
{
    FAAddGroupView *addgroupview;
    PBdataClass *pb;
    PBdataClass *deletedb;
    int numsection;
}
@property(nonatomic,retain)NSMutableArray *projectListArry;
@property(nonatomic,retain)MyProject *myproject;
@property(nonatomic,retain)NSString *proname;
@end
