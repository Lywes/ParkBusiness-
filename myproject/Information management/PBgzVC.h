//
//  PBgzVC.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBgzVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSMutableArray *celltext;
    NSMutableArray *cellcontview;

}
@property(nonatomic,retain)NSMutableDictionary *guanzhu;
@end
