//
//  FAMessageData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAMessageData : NSObject

+(NSMutableArray*)searchByFriendid:(int)friendid
                   groupid:(int)groupid
                         isreadflg:(int)isread;
+(int)saveId:(int)no
    friendid:(int)friendid
     groupid:(int)groupid
     content:(NSString*)content
  friendname:(NSString*)friendname
     imgpath:(NSString*)imgpath
      isread:(int)isread
     whosaid:(int)whosaid
  createtime:(NSDate*)createtime
   actionflg:(int)actionflg;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
+(void)deleteMessageByFriendId:(int)friendid;
+(void)deleteMessageByGId:(int)gid;
+(void)updateMessageReadflgById:(int)friendid groupid:(int)groupid groupflg:(int)groupflg;
+(int)getUnreadContentCountByGId:(int)gid friendid:(int)friendid groupflg:(int)groupflg;
+(NSString *)getDialogContentByGId:(int)gid friendid:(int)friendid createtime:(int)time;
+(NSMutableArray*)getUnreadDialog;
+(int)getActionflgByGId:(int)gid;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite) int friendid;
@property(nonatomic,readwrite) int groupid;
@property(nonatomic,retain,readwrite) NSString* content;
@property(nonatomic,retain,readwrite) NSString* imgpath;
@property(nonatomic,retain,readwrite) NSString* friendname;
@property(nonatomic,readwrite) int isread;
@property(nonatomic,readwrite) int whosaid;
@property(nonatomic,readwrite) int actionflg;
@property(nonatomic,retain,readwrite) NSDate* createtime;
@property(nonatomic,readwrite) int count;
@property(nonatomic,readwrite) int groupflg;
@end
