//
//  PBAddFinanceData.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBFinanceAccountData.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBBankLoanData.h"
#import "PBActivityIndicatorView.h"
@interface PBAddFinanceData : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    UITextView *othersView;//备注说明
    NSMutableArray *textFieldArr;
    CGFloat height;
    int keyno;//主键
    UIImage *NewImage;
    NSString* companyname;
}

@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int year;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBFinanceAccountData *pbfinanceData;
@property(nonatomic,assign)int projectno;
@end
