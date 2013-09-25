//
//  FAInviteInfoData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAInviteInfoData : NSObject

+(NSMutableArray*)search:(int)no;
+(int)saveId:(int)no
     fromid:(int)fromid
       alert:(NSString*)alert
      kind:(int)kind
    username:(NSString*)username
      groupid:(int)groupid
    groupname:(NSString*)groupname
         flg:(int)flg;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite) int fromid;
@property(nonatomic,retain,readwrite) NSString* alert;
@property(nonatomic,readwrite) int kind;
@property(nonatomic,retain,readwrite) NSString* username;
@property(nonatomic,readwrite) int groupid;
@property(nonatomic,retain,readwrite) NSString* groupname;
@property(nonatomic,readwrite) int flg;

@end
