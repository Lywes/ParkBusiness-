//
//  PBprojectteam.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBzuijia.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBprojectteam : UITableViewController<PBdataClassDelegate>
{
    NSMutableArray *teammembers;//团队成员信息
    NSInteger numbersection;
    
    PBzuijia * zuijia;
    PBActivityIndicatorView *activity;
    PBdataClass *pbdataclass;
}
@property(nonatomic,retain)NSMutableArray *teammembers;
@property(nonatomic,assign)NSInteger projectno;
@property(nonatomic,retain)NSString *ProjectStyle;
@property(nonatomic,retain)NSDictionary *datadic;//从别的页面跳转进来，进行数据只读操作的数据接口
@end
