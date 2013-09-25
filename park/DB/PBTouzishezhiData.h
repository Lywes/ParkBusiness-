//
//  PBTouzishezhiData.h
//  ParkBusiness
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBTouzishezhiData : NSObject
+(NSMutableArray*)search;
+(int)SaveId:(int)no 
        investtrade:(NSString *)investtrade 
         investsubdivision:(NSString *)investsubdivision 
        annualinvestno:(NSString *)annualinvestno 
        projectfund_avg:(int)projectfund_avg
        carveoutresourse:(NSString *)carveoutresourse;

@property (nonatomic,assign) int no;
@property (nonatomic,retain,readwrite) NSString *investtrade;
@property (nonatomic,retain,readwrite) NSString *investsubdivision;
@property (nonatomic,retain,readwrite) NSString *annualinvestno;
@property (nonatomic,readwrite) int projectfund_avg;
@property (nonatomic,retain,readwrite) NSString *carveoutresourse;

@end
