//
//  PBActivityReceipt.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBActivityReceipt : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,PBdataClassDelegate,UIAlertViewDelegate>{
    PBActivityIndicatorView*acitivity;
    UITextField *name;
    UITextField *tel;
    UITextField *amount;
    UILabel *joblabel;//申请人性质
    //POPview
    POPView *pop;
    //本地表
    NSMutableArray *job;
    CGFloat height;
}
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,assign)int projectno;



@end
