//
//  FAGroupMemberData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAGroupMemberData : NSObject

+(NSMutableArray*)search:(int)gid
                   limit:(int)limitNumber;
+(int)saveId:(int)no
     groupid:(int)groupid
     userid:(int)userid
   username:(NSString*)username
  createtime:(NSDate*)createtime;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
+(BOOL)isGroupMember:(int)groupid byuser:(int)userid;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite) int groupid;
@property(nonatomic,readwrite) int userid;
@property(nonatomic,retain,readwrite) NSString* username;
@property(nonatomic,retain,readwrite) NSDate* createtime;

@end
