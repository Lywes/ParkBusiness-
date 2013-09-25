//
//  PBBusinessFiancingNeed.h
//  ParkBusiness
//
//  Created by China on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsuperviewVC.h"

@interface PBBusinessFiancingNeed : PBsuperviewVC
@property(nonatomic,retain)NSMutableArray * quanbu_arr;
@property(nonatomic,retain)NSMutableArray * weijieda_arr;
@property(nonatomic,retain)NSMutableArray * yijieda_arr;
@property(nonatomic,retain)IBOutlet UILabel *name;
@property(nonatomic,retain)IBOutlet UILabel *use;
@property(nonatomic,retain)IBOutlet UILabel *funds;
@end
