//
//  PBAmountUnitData.h
//  ParkBusiness
//
//  Created by  on 13-4-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBAmountUnitData : NSObject

+(NSMutableArray*)search;
@property(nonatomic,assign) int no;
@property(nonatomic,retain) NSString *kind;
@property(nonatomic,retain) NSString *name;
@end
