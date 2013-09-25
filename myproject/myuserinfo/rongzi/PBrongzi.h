//
//  PBrongzi.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBdataClass.h"
#import "PBProjectData.h"
#import "POPView.h"
#import "PBActivityIndicatorView.h"
@interface PBrongzi : PBtableViewEdit<PBdataClassDelegate,UIListViewDelegate>
{
    UITextField *financingamount;//融资额度
    UILabel *amountunit;//融资单位
    UILabel *rate;//出让股权比例
    POPView *amountunitview;
    POPView *rateview;
    PBActivityIndicatorView*activity;
}
@property(nonatomic,retain)NSMutableArray *textfield_arry;
@property(nonatomic,retain)NSMutableArray *stringdanwei_arry;
@property(nonatomic,retain)NSMutableArray *stringbili_arry;
@property(nonatomic,retain)PBProjectData *pbprojectdata;
@property(nonatomic,assign)int projectno;
@end
