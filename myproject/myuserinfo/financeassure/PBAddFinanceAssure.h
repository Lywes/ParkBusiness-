//
//  PBAddFinanceAssure.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBFinanceAssureData.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@class PBFinanceAssureData;
@interface PBAddFinanceAssure : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    UITextField *loanapply;//申请贷款额
    UITextField *enterprise;//借贷期限
    UITextField* creditamount;
    UITextField* creditlimit;
    UITextField* assurerate;
    UILabel *loanbankname;//申请人性质
    UILabel *applyproperty;//申请人性质
    UILabel *applycredituse;//申请授信用途
    UILabel *repaytypelabel;//还款方式
    //POPview
    POPView *pop;
    NSMutableArray *pop_arry;
    //本地表
    NSMutableArray *property;
    NSMutableArray * repaytype;
    NSMutableArray * credituse;
    CGFloat height;
}
@property(nonatomic,retain)NSString *datestring;
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBFinanceAssureData *pbdata;
@property(nonatomic,assign)int projectno;
@end
