//
//  PBBusinessFiancingdetail.h
//  ParkBusiness
//
//  Created by China on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"
#import "PBdataClass.h"
@interface PBBusinessFiancingdetail : UIViewController<UITableViewDataSource,UITableViewDelegate,UIInputToolbarDelegate,PBdataClassDelegate>
{
    NSMutableArray *_sectiontitle_arr;
    NSMutableArray *_arry;//修改项，或者赋予一个真实值，其他可不动；
    UIInputToolbar *inputbar;//回答输入框；
}
@property(nonatomic,retain)IBOutlet UILabel *name;
@property(nonatomic,retain)IBOutlet UILabel *trade;
@property(nonatomic,retain)IBOutlet UILabel *funds;
@property(nonatomic,retain)IBOutlet UILabel *saleroom;
@property(nonatomic,retain)UILabel *use;
@property(nonatomic,retain)UILabel *difficulty;
@property(nonatomic,retain)UIButton *answer;
@property(nonatomic,retain)IBOutlet UITableView *tbview;
@property(nonatomic,retain) NSDictionary *data_dic;

@property(nonatomic,retain)IBOutlet UILabel *name_identification;
@property(nonatomic,retain)IBOutlet UILabel *founs_identification;
@property(nonatomic,retain)IBOutlet UILabel *trade_identification;
@property(nonatomic,retain)IBOutlet UILabel *salerroom_identification;
-(void)butpress:(id)sender;
@end
