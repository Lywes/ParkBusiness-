//
//  FAFriendGroupData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAFriendGroupData : NSObject
+(BOOL)checkGroupNameExist:(NSString*)name;
+(void)saveFriendGroupMemberInfo:(int)no fid:(int)fid fgid:(int)fgid;
+(void)deleteFriendGroupMemberWithFid:(int)fid;
+(NSMutableArray*)search:(int)no name:(NSString*)name limit:(int)limitNumber;
+(NSMutableArray*)searchGroupInfoWithFriendId:(int)no;
+(int)searchMaxIdx;
+(int)exchangeFromNo:(NSUInteger)no toIdx:(NSUInteger)toIdx;
+(int)saveId:(int)no
        name:(NSString*)name
         idx:(int)idx;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,retain,readwrite) NSString* name;
@property(nonatomic,readwrite) int idx;
@property(nonatomic,retain,readwrite) NSString* flag;
@end
