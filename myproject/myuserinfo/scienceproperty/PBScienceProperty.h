//
//  PBScienceProperty.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "POPView.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
#import "PBtextField.h"
#import "PBCompanyData.h"
@class PBProjectData;
@interface PBScienceProperty : PBtableViewEdit<PBdataClassDelegate>{
    PBActivityIndicatorView*acitivity;
    PBtextField *pbtextfield;
}

@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBProjectData *pbdata;
@property(nonatomic,assign)int projectno;
@property(nonatomic,retain)NSMutableDictionary *textDic;
@end
