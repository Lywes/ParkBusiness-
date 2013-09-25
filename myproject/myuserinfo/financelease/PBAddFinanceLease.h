//
//  PBAddFinanceLease.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBFinanceLeaseData.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@class PBFinanceLeaseData;
@interface PBAddFinanceLease : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    UITextField *projectamount;
    UITextView* leasedeviceinfo;
    UILabel *typelabel;//申请人性质
    //POPview
    POPView *pop;
    //本地表
    NSMutableArray *leasetype;
    CGFloat height;
}
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBFinanceLeaseData *pbdata;
@property(nonatomic,assign)int projectno;

@end
