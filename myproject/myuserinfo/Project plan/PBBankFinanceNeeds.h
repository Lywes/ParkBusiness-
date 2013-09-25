//
//  PBBankFinanceNeeds.h
//  ParkBusiness
//
//  Created by QDS on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#import "PBtableViewEdit.h"
#import "PBBankLoanData.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBBankFinanceNeeds : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    UITextField *applyloan;//申请贷款额
    UITextField *loanlimit;//借贷期限
    UITextView* others;
    UILabel *securedform;//担保形式
    UILabel *yearraterange;//年利率范围
    UILabel *loanuselabel;//贷款用途
    //POPview
    POPView *pop;
    NSMutableArray *pop_arry;
    //本地表
    NSMutableArray *assure;
    NSMutableArray * raterange;
    NSMutableArray * loanuse;
    CGFloat height;
    int keyno;//主键
}

@property(nonatomic,retain)NSString *datestring;
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBBankLoanData *pbbankloandata;
@property(nonatomic,assign)int projectno;

@end
