//
//  PBSettings.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-9.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBtableViewEdit.h"
#import "PBtextField.h"
#import "PBIndustryData.h"
#import "POPView.h"
#import "PBShezhiData.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
@interface PBSettings : PBtableViewEdit<UIListViewDelegate,imageviewPickerdelegate,PBdataClassDelegate>
{
    NSArray *sc1;
    NSArray *sc2;
    NSArray *sc3;
    NSArray *sc4;
    PBtextField *pbtextfield;
    //
    NSMutableArray *sex;
    NSMutableArray *companyjob;
    NSMutableArray *industry;
    NSMutableArray *city;
    NSMutableDictionary *head;
    POPView *jobpop;
    POPView *sexpop;
    POPView *hangyepop;
    POPView *suozaichengshi;
    PBShezhiData *shezhidata;
    NSMutableDictionary *dic;
    UIImageView *pic;
    ImagePickerView *imagepickerview;
    int keyno;//主键
    UIImage *NewImage;
    PBActivityIndicatorView *activity;
}
@property(nonatomic,retain)UIImageView *imageview;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic,retain)NSMutableDictionary *dic;
@property(nonatomic,retain)NSMutableArray *keys;
@property(nonatomic,retain)NSString *touzianli;
- (id)initWithStyle:(UITableViewStyle)style withString:(NSString *)str;

@end
