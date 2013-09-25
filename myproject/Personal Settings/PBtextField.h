//
//  PBtextField.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-9.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"

@class PBSettings;
@class PBAddCompanyView;
@class PBScienceProperty;
@interface PBtextField : PBtableViewEdit
{
    UILabel *lable;
    BOOL whattext;
}
@property(nonatomic,retain)UITextField *textfield;
@property(nonatomic,retain)UITableView *tableview1;
@property(nonatomic,retain)NSIndexPath *indepath;
@property(nonatomic,assign)PBSettings *setting;
@property(nonatomic,assign)PBScienceProperty *science;
@property(nonatomic,assign)PBAddCompanyView *addCompany;
@property(nonatomic,retain) NSString *equstr;
@property(nonatomic,retain) NSString *detailStr;
@end
