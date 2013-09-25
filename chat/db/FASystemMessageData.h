//
//  FASystemMessageData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FASystemMessageData : NSObject

+(NSMutableArray*)search:(int)no
                   limit:(int)limitNumber;
+(int)saveId:(int)no
     isread:(int)isread
object:(NSString*)object
      formatid:(int)formatid
    content:(NSString*)content
  createtime:(NSDate*)createtime;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
+(void)updateIsreadFlgByNo:(int)no limitFlg:(BOOL)flg;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite) int isread;
@property(nonatomic,retain,readwrite) NSString* object;
@property(nonatomic,readwrite) int formatid;
@property(nonatomic,retain,readwrite) NSString* content;
@property(nonatomic,retain,readwrite) NSDate* createtime;

@end
