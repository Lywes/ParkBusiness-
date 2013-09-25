//
//  PBguanzhu.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsuperviewVC.h"
#import "PBdataClass.h"
#import "PBgzVC.h"
@interface PBguanzhu : PBsuperviewVC
{
    PBdataClass *attention;
    PBdataClass *attentionInfo;
    PBgzVC *pbgzvc;
}
@property(nonatomic,retain)NSMutableArray *touziren_arry;
@property(nonatomic,retain)NSMutableArray *qiyejia_arry;
@property(nonatomic,retain)NSMutableArray *zhengfu_arry;
@property(nonatomic,retain)NSMutableArray *guanzhu_arry;
-(void)getInfoFromattentionBynoAtIdexpath:(NSIndexPath *)indexpath;
@end
