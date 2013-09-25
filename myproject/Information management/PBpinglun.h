//
//  PBpinglun.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsuperviewVC.h"
#import "PBdataClass.h"
#import "PBgzVC.h"
@interface PBpinglun : PBsuperviewVC<PBdataClassDelegate>
{
    PBdataClass *attention;
    PBdataClass *attentionInfo;
    PBgzVC *pbgzvc;
}

@property(nonatomic,retain)NSMutableArray *pinglun_arry;
@end
