//
//  PBtableViewEdit.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBteamData.h"
#import "POPView.h"
#import "PBdataClass.h"
#import "ImagePickerView.h"
#import "PBActivityIndicatorView.h"

@interface PBzuijia : PBtableViewEdit<UIListViewDelegate,PBdataClassDelegate,imageviewPickerdelegate>
{
    UISwitch *swith1;
    UISwitch *swith2;
    NSArray *textlable_arry;
    UILabel *teamjob;//团队角色
    UITextField *years;//工作年数
    ImagePickerView *imagepickerview;
    POPView *pop;
    NSInteger no;
    UIImageView *LogImageAC;
    UILabel *picturelable;
    PBActivityIndicatorView *activity;
    UIImage *NewImage;
    NSInteger keyno;
}
@property(nonatomic,retain)UISwitch *swith1;
@property(nonatomic,retain)UISwitch *swith2;
@property(nonatomic,retain)NSArray *textlable_arry;
@property(nonatomic,retain)NSMutableArray *memberinfos;
@property(nonatomic,retain)NSString *ProjectStyle;//判断只读数据操作
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,assign) NSInteger projectno;


@end
