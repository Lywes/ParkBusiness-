//
//  PBAddPatentInfo.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-25.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBPatantData.h"
#import "PBActivityIndicatorView.h"
@class PBdatepick;
@class PBPatantData;
@interface PBAddPatentInfo : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate>
{
    
    PBActivityIndicatorView*acitivity;
    UITextField *name;//专利名称
    UITextField *patentno;//专利号
    UITextField *acceptdate;//受理时间
    UITextField *authorizedate;//授权时间
    NSString *datestring;//时间
    PBdatepick *pbdatepicker;//时间选择器
    //POPview
    POPView *pop;
    //本地表
    UILabel *patentStr;//专利类型
    NSMutableArray *patenttype;
    NSDateFormatter* formatter;
}

@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBPatantData *pbdata;
@property(nonatomic,assign)int projectno;

@end
