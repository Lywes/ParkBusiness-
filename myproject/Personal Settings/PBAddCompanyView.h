//
//  PBAddCompanyView.h
//  ParkBusiness
//
//  Created by QDS on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "POPView.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
#import "PBtextField.h"
#import "PBCompanyData.h"
@class PBSettings;
@class PBCompanyChoose;
@interface PBAddCompanyView : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,imageviewPickerdelegate,PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    ImagePickerView *imagepickerview;
    UIImageView *LogImageAC;
    UILabel *picturelabel;
    //POPview
    POPView *pop;
    //本地表
    NSMutableArray *industry;
    CGFloat height;
    int keyno;//主键
    UIImage *NewImage;
    PBdataClass* productData;
    NSDateFormatter* formatter;
    UILabel* companyname;//公司名称
    UITextField* organizingcode;//组织机构代码
    UITextField* taxregistry;//税务登记证号
    UITextField* representative;//法人代表
    UITextField* bank;//开户行
    UITextField* companyaccount;//公司账户
    UITextField* accountname;//账户名
    UITextField* telephone;//联系电话
    UITextField* address;//办公地点
    UITextField *yearsale;//上年度销售额
    UITextField *yearprofit;//上年度盈利
    UITextField *fixedassets;//固定资产
    UILabel *staffnum;//员工人数
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
    //本地表
    NSMutableArray *staff;//员工人数
    NSMutableArray *operatesite;//实际场地
    NSMutableArray *judgment;//涉及
    NSMutableArray *check;//具有
    
}

@property(nonatomic,retain)NSString *datestring;
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBCompanyData *pbdata;
@property(nonatomic,assign)int projectno;
@property(nonatomic,retain)PBSettings* popController;
@property(nonatomic,retain)PBCompanyChoose* choose;
@property(nonatomic,retain,readwrite)PBCompanyData *companydata;


@end
