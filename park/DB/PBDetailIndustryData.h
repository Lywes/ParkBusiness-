//
//  PBDetailIndustryData.h
//  ParkBusiness
//
//  Created by  on 13-4-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBDetailIndustryData : NSObject
+(NSMutableArray *)searchInducstry:(int)num;
@property(nonatomic,assign) int no;
@property(nonatomic,retain) NSString *kind;
@property(nonatomic,retain) NSString *name;
@end
