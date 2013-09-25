//
//  FAGroupData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAGroupData : NSObject

+(NSMutableArray*)search:(int)no name:(NSString*)name limit:(int)limitNumber;
+(int)saveId:(int)no
     groupid:(int)groupid
        flag:(int)flag
   groupname:(NSString*)groupname
     imgpath:(NSString*)imgpath
  createtime:(NSDate*)createtime;
+(NSMutableArray*)searchInstitude:(int)groupid
                             name:(NSString*)name
                            limit:(int)limitNumber;
-(void)saveRecord;
+(void)deleteInstitudeData;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
+(FAGroupData *)getGroupDataById:(int)groupid;
+(FAGroupData *)getInstitudeDataById:(int)groupid;
+(int)getGroupFlagById:(int)groupid;
+(BOOL)isOldGroup:(int)groupid;
+(NSMutableArray*)searchGroupDataWithFlag:(int)flag withoutGid:(int)gid;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite)int flag;
@property(nonatomic,readwrite) int groupid;
@property(nonatomic,retain,readwrite) NSString* imgpath;
@property(nonatomic,retain,readwrite) NSString* groupname;
@property(nonatomic,retain,readwrite) NSDate* createtime;

@end
