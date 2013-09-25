//
//  PBaddprojectplan.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBPlanData.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"

@interface PBaddprojectplan : PBtableViewEdit<PBdataClassDelegate>
{
    UITextField *stdate;//项目 开始时间
    UITextField *totalbudget;//支出费用总运算
    UITextField *salestarget;//销售收入目标
    UITextField *profittarget;//盈亏目标

    UITextView *teambiulding;//团队建设
    UITextView *productdev;//产品开发
    
    NSString *no;
    CGPoint point;
    NSString *className;
    NSInteger number;
    PBActivityIndicatorView *activity;
    NSInteger keyno;
}
@property(nonatomic,retain)NSMutableArray *feiyong_arry;
@property(nonatomic,retain)NSMutableArray *textfield_arry;
@property(nonatomic,retain)NSMutableArray*textview_arry;
@property(nonatomic,retain)UIDatePicker *datepicker;
//@property(nonatomic,retain)NSMutableDictionary *_datas;//页面数据
@property(nonatomic,retain)NSMutableArray *_datas;//页面数据
@property(nonatomic,assign)NSInteger number;//数据索引
@property(nonatomic,retain)NSString *className;//类的名称
@property(nonatomic,assign)int projectno;
@end
