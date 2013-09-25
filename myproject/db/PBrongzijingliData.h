//
//  PBrongzijingliData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBrongzijingliData : NSObject
+(NSMutableArray*)searchWhereProjectno:(int)projectno;
+(int)SaveId:(int)no 
        projectno:(int)projectno 
     invsetstage:(int)invsetstage
   invsetamount:(NSString *)invsetamount 
       amountunit:(int)amountunit
     	financetime:(NSString *)financetime 
   investors:(NSString *)investors;
-(void)saveRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite) int invsetstage;
@property(nonatomic,retain,readwrite) NSString* invsetamount;
@property(nonatomic,readwrite) int amountunit;
@property(nonatomic,retain,readwrite) NSString* financetime;
@property(nonatomic,retain,readwrite) NSString* investors;
@property(nonatomic,readwrite)int projectno;
@end
