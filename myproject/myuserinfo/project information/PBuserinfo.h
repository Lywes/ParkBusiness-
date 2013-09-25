//
//  PBuserinfo.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-2-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBtableViewEdit.h"
#import "PBProjectData.h"
#import "POPView.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@class MyProject;
@class PBdatepick;
@interface PBuserinfo : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,imageviewPickerdelegate,PBdataClassDelegate>
{
    
    PBActivityIndicatorView*acitivity;
    UILabel *hangyehuafen;//行业划分
    UILabel *companyname;//公司名称
    UITextField *projectstartime;//项目开始时间
    UILabel *_projectjieduan;//项目阶段
    NSString *datestring;//时间
    PBdatepick *pbdatepicker;//时间选择器
    UIImageView *LogImageAC;
    NSString *lbtxt_projectname;
    NSString *lbtxt_hangyehuafen;
    NSString *lbtxt_projectjieshao;
    NSString *lbtxt_projectstartime;
    NSString *lbtex_projectjieduan;
    NSString *lbtex_chuanyejingli;
//    BOOL edit;
   
    
    //POPview
    POPView *pop;
    NSMutableArray *pop_arry;
    //本地表
    NSMutableArray *industry;
    NSMutableArray *stage;
    ImagePickerView *imagepickerview;
     CGFloat height;
    int keyno;//主键
    UILabel *picturelabel;
    UIImage *NewImage;
}

@property(nonatomic,retain)UITextField *projectstartime;
@property(nonatomic,retain)NSString *datestring;
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)PBdatepick *pbdatepicker;
@property(nonatomic,retain)NSString *lbtxt_projectname;
@property(nonatomic,retain)NSString *lbtxt_projectjieshao;
@property(nonatomic,retain)NSString *lbtxt_hangyehuafen;
@property(nonatomic,retain)NSString *lbtex_projectjieduan;
@property(nonatomic,retain)NSString *lbtxt_projectstartime;
@property(nonatomic,retain)NSString *lbtex_chuanyejingli;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,retain)PBProjectData *pbprojectdata;
@property(nonatomic,retain)MyProject *popController;
@property(nonatomic,assign)int projectno;


@end
