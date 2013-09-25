//
//  PBAssureCompanyInfo.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBProjectData.h"
#import "POPView.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBBankLoanData.h"
#import "PBActivityIndicatorView.h"
#import "PBPurchaseFinanceProduct.h"
@class PBCompanyData;
@interface PBAssureCompanyInfo : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate>{
    PBdataClass* productData;
    PBActivityIndicatorView*acitivity;
    NSDateFormatter* formatter;
    UITextField *yearsale;//上年度销售额
    UITextField *yearprofit;//上年度盈利
    UITextField *fixedassets;//固定资产
    UILabel *staffnum;//员工人数
    UIImageView *LogImageAC;//公司图片
    UITextField *receiptfund;//实收资本
    UITextField *registerfund;//注册资本
    UITextField *totaldebt;//企业总负债
    UITextView* mainproducts;//主营产品
    UITextView* tradeinfo;//行业情况
    UITextView* customerinfo;//下游客户
    UILabel* actualsite;//实际场地
    UITextField* leasedate;//租约截止日期
    UITextField *averagerent;//月平均租金
    UILabel* isfranchise;//涉及特许经营
    UILabel* havefranchise;//具有特许经营
    //POPview
    POPView *pop;
    NSMutableArray *pop_arry;
    //本地表
    NSMutableArray *staff;//员工人数
    NSMutableArray *operatesite;//实际场地
    NSMutableArray *judgment;//涉及
    NSMutableArray *check;//具有
    CGFloat height;
    int keyno;//主键
    UIImage *NewImage;
    NSString* companyname;
}

@property(nonatomic,retain)NSString *mode;
@property(nonatomic,retain)PBCompanyData *companydata;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)PBPurchaseFinanceProduct* popController;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,assign)int projectno;
@property(nonatomic,assign)BOOL GOFinacing;

@end
