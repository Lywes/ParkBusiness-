//
//  PBAddInsureInfo.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBAddInsureInfo : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    UILabel *insurename;
    UILabel *insurelimit;
    UILabel* unit;
    UITextField* paynum;
    UITextView* others;
    CGFloat height;
}
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,assign)int projectno;

@end
