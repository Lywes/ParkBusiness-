//
//  PBtrendData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBtrendData : NSObject
+(NSMutableArray*)searchByprojectno:(int)prjectno;
+(int)SaveId:(int)no 
    prjectno:(int)projectno
   condition:(NSString *)condition
       cdate:(NSString *)cdate;  
-(void)saveRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite)int projectno;
@property(nonatomic,retain,readwrite) NSString* condition;
@property(nonatomic,retain,readwrite) NSString* cdate;
@end
