//
//  FAFriendGroupEditView.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAAddGroupView.h"
#import "FAFriendGroupData.h"
#import <QuartzCore/QuartzCore.h>
@interface FAFriendGroupEditView : UIViewController<UITableViewDelegate,UITableViewDataSource,FAAddGroupViewDelegete>{
    FAAddGroupView* addGroupView;
    
}
@property(strong,nonatomic)NSMutableArray* friendGroupArry;
@property(strong,nonatomic)UITableView* tableViews;
@end
