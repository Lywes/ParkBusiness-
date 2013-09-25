//
//  PBAddCompanyBand.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBCompanyBondData.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"

@class PBCompanyBondData;
@interface PBAddCompanyBand : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate,SuccessSendMessage>{
    PBActivityIndicatorView*acitivity;
    UITextField *issueamount;
    UITextField *bondamount;
    UITextField* yearprofit;
    UITextView* others;
    UILabel *bondtypelabel;//申请人性质
    UILabel *debttoequity;//申请人性质
    //POPview
    POPView *pop;
    NSMutableArray *pop_arry;
    //本地表
    NSMutableArray *bondtype;
    NSMutableArray * judgment;
    CGFloat height;
}
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBCompanyBondData *pbdata;
@property(nonatomic,assign)int projectno;
@property(nonatomic,assign)int productno;
@end
