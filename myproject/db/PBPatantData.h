//
//  PBPatantData.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBPatantData : NSObject
+(NSMutableArray*)searchData:(int)projectno;
+(void)deleteRecord:(int)recordId;
+(int)saveId:(int)no
projectno:(int)projectno
type:(int)type
name:(NSString*)name
patentno:(NSString*)patentno
acceptdate:(NSDate*)acceptdate
authorizedate:(NSDate*)authorizedate;
-(void)saveRecord;
@property(nonatomic,assign) int no;
@property(nonatomic,assign) int projectno;
@property(nonatomic,assign) int type;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* patentno;
@property(nonatomic,retain) NSDate* acceptdate;
@property(nonatomic,retain) NSDate* authorizedate;
@end
