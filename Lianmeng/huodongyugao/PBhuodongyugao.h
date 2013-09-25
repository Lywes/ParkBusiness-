//
//  PBhuodongyugao.h
//  PBBank
//
//  Created by lywes lee on 13-5-7.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

/*
 此部分的数据处理：
    类似与下面例子
     NSArray *ar0 = [NSArray arrayWithObjects:@"1", nil];
     NSArray *ar1 = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
     NSArray *ar2 = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
     NSArray *ar3 = [NSArray arrayWithObjects:@"", nil];
     NSArray *ar4 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
     NSArray *ar5 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
     self.DataArr = [NSMutableArray arrayWithObjects:ar0,ar1,ar2,ar3,ar4,ar5, nil];
 其中数组里面的数据是从服务器上得到的数据，因为从服务器上返回的数据是一个字典，解析字典得到1，2，3等数据加入每一个数组中，其中ar0代表 section = 0 的数据，
 ar1代表 section = 1 的数据，依次类推。所以self.DataArr里的数据是每一个section里面的数据
 */
#import "UITbavleViewControllerModel.h"
@interface PBhuodongyugao
: UITbavleViewControllerModel
@property(nonatomic,retain)NSString *no;

@end
