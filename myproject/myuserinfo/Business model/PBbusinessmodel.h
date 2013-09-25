//
//  PBbusinessmodel.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBdataClass.h"
#import "PBProjectData.h"
#import "POPView.h"
#import "PBActivityIndicatorView.h"
@interface PBbusinessmodel : PBtableViewEdit<PBdataClassDelegate,UIListViewDelegate>
{
    UILabel *modetype;
    POPView *popview;
    NSMutableArray *modletype;
    UITextView* productText;
    UITextView* potentText;
    PBActivityIndicatorView*acitivity;
}
@property(nonatomic,retain)NSMutableArray *_datas;
@property(nonatomic,retain)PBProjectData *pbprojectdata;
@property(nonatomic,assign)int projectno;
@end
