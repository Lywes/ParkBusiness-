//
//  PBhuodong.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsuperviewVC.h"
#import "PBdataClass.h"
@interface PBhuodong : PBsuperviewVC<PBdataClassDelegate>
{
}
@property(nonatomic,retain)NSMutableArray * huodong_arry;
@end
