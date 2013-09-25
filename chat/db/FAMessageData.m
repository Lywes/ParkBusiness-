//
//  FAMessageData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAMessageData.h"
static sqlite3* database = nil;
@implementation FAMessageData
@synthesize no,friendid,groupid,content,isread,whosaid,createtime,count,imgpath,friendname,groupflg,actionflg;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
        actionflg = 0;
    }
    return self;
}
+(NSMutableArray*)searchByFriendid:(int)friendid
                           groupid:(int)groupid
                         isreadflg:(int)isread
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *friendmessageSql = [[NSString stringWithFormat:@"%@",@"select * from message_master where friendid = ? and groupid='0' and createtime>? order by createtime "]UTF8String];
    const char *groupmessageSql = [[NSString stringWithFormat:@"%@",@"select * from message_master where groupid =? and createtime > ? order by createtime  "]UTF8String];
    const char *institudemessageSql = [[NSString stringWithFormat:@"%@",@"select * from message_master where groupid =? and friendid = ? and createtime > ? order by createtime  "]UTF8String];
    
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = friendmessageSql;
    if (groupid > 0&&friendid>0) {
        sql = institudemessageSql;
    }else if (groupid > 0) {
        sql = groupmessageSql;
    }
    
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        int i = 2;
        if (groupid > 0&&friendid>0) {
            sqlite3_bind_int(stmt, 1, groupid);
            sqlite3_bind_int(stmt, 2, friendid);
            i = 3;
        }else if(groupid>0){
            sqlite3_bind_int(stmt, 1, groupid);
        }else{
            sqlite3_bind_int(stmt, 1, friendid);
        }
        int seconds = 7*24*60*60;
        sqlite3_bind_int(stmt, i, [[NSDate date] timeIntervalSince1970]-seconds);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAMessageData* data = [[FAMessageData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.friendid = (int)sqlite3_column_int(stmt, 1);
            data.groupid = (int)sqlite3_column_int(stmt, 2);
            char* cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.content = [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 4);
            if (cName)
                data.friendname = [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 5);
            if (cName)
                data.imgpath = [NSString stringWithUTF8String:cName];
            data.isread = (int)sqlite3_column_int(stmt, 6);
            data.whosaid = (int)sqlite3_column_int(stmt, 7);
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 8)];
            
            [listData   addObject:data];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return listData;
}

+(int)saveId:(int)no
    friendid:(int)friendid
     groupid:(int)groupid
     content:(NSString*)content
     friendname:(NSString*)friendname
     imgpath:(NSString*)imgpath
      isread:(int)isread
     whosaid:(int)whosaid
  createtime:(NSDate*)createtime
actionflg:(int)actionflg
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into message_master(id,friendid,groupid,content,friendname,imgpath,isread,whosaid,createtime,actionflg",@") Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return -1;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return -1;
    }
    if (no == -1||no == 0) {
        
    }else{
        sqlite3_bind_int(stmt, 1, no);
    }
    sqlite3_bind_int(stmt, 2, friendid);
    sqlite3_bind_int(stmt, 3, groupid);
    sqlite3_bind_text(stmt, 4, [content UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [friendname UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 6, [imgpath UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 7, isread);
    sqlite3_bind_int(stmt, 8, whosaid);
    sqlite3_bind_int(stmt, 9, [createtime timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 10, actionflg);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
-(void)saveRecord
{
    no = [FAMessageData saveId:self.no friendid:self.friendid groupid:self.groupid content:self.content friendname:self.friendname imgpath:self.imgpath isread:self.isread whosaid:self.whosaid createtime:self.createtime actionflg:self.actionflg];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from message_master where id = ? ";
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return;
    }
    sqlite3_bind_int(stmt, 1, recordId);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    
}

-(void)deleteRecord
{
    [FAMessageData deleteId:self.no];
}
+(void)deleteMessageByFriendId:(int)friendid{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from message_master where friendid = ? and groupid is null and isread=1 ";
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return;
    }
    sqlite3_bind_int(stmt, 1, friendid);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
}
+(void)deleteMessageByGId:(int)gid{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from message_master where groupid = ? and friendid is null and isread=1 ";
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return;
    }
    sqlite3_bind_int(stmt, 1, gid);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
}
+(void)updateMessageReadflgById:(int)friendid groupid:(int)groupid groupflg:(int)groupflg
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *groupsql = "update message_master set isread=1 where groupid = ? and isread=0 ";
    const char *friendsql = "update message_master set isread=1 where groupid = ? and friendid=? and isread=0 ";
    const char *sql = friendsql;
    if (groupid>0&&(groupflg==0||[PBUserModel getPasswordAndKind].kind == 2)) {
        sql = groupsql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return;
    }
    if (groupid>0&&(groupflg==0||[PBUserModel getPasswordAndKind].kind == 2)) {
        sqlite3_bind_int(stmt, 1, groupid);
    }else{
        sqlite3_bind_int(stmt, 1, groupid);
        sqlite3_bind_int(stmt, 2, friendid);
    }
    
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
}
+(int)getUnreadContentCountByGId:(int)gid friendid:(int)friendid groupflg:(int)groupflg{
    int curcount=1;
    sqlite3_stmt *stmt = nil;
    const char *groupsql = [[NSString stringWithFormat:@"%@",@"select count(a.id) from message_master a left join groupmaster as b on b.groupid = a.groupid where a.groupid = ? and isread=0 "]UTF8String];
    const char *friendsql = [[NSString stringWithFormat:@"%@",@"select count(id) from message_master where groupid =? and isread=0 and friendid = ?"]UTF8String];
    const char *sql = friendsql;
    if (gid>0&&(groupflg==0||[PBUserModel getPasswordAndKind].kind == 2)) {
        sql = groupsql;
    }
        
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if (gid >0&&(groupflg==0||[PBUserModel getPasswordAndKind].kind == 2)) {
            sqlite3_bind_int(stmt, 1, gid);
        }else{
            sqlite3_bind_int(stmt, 1, gid);
            sqlite3_bind_int(stmt, 2, friendid);
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            curcount = (int)sqlite3_column_int(stmt, 0);
            
            break;
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
    return curcount;
}
+(NSString *)getDialogContentByGId:(int)gid friendid:(int)friendid createtime:(int)time{
    // [listData retain];
    NSString *content=nil;
    
    sqlite3_stmt *stmt = nil;
    const char *groupsql = [[NSString stringWithFormat:@"%@",@"select content from message_master where groupid =? and friendid = ? and createtime=? "]UTF8String];
    const char *friendsql = [[NSString stringWithFormat:@"%@",@"select content from message_master where groupid ='0' and friendid = ? and createtime=?"]UTF8String];
//    const char *institudesql = [[NSString stringWithFormat:@"%@",@"select content from message_master where groupid =? and friendid = ? and createtime=?"]UTF8String];
    const char *sql = friendsql;
    if (gid>0) {
        sql = groupsql;
    }
    
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if (gid >0) {
            sqlite3_bind_int(stmt, 1, gid);
            sqlite3_bind_int(stmt, 2, friendid);
            sqlite3_bind_int(stmt, 3, time);
        }else{
            sqlite3_bind_int(stmt, 1, friendid);
            sqlite3_bind_int(stmt, 2, time);
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            char* cName = (char*)sqlite3_column_text(stmt, 0);
            if (cName)
                content = [NSString stringWithUTF8String:cName];

            break;
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    return content;
}
+(NSMutableArray*)getUnreadDialog{//获取会话数据
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    //企业家身份
    const char *sql = [[NSString stringWithFormat:@"%@",@"select createtime,friendid,groupid,groupflg,imgpath,friendname,content from (select max(a.createtime) as createtime,a.friendid,a.groupid,b.flag as groupflg,a.imgpath,a.friendname,a.content from message_master a left join groupmaster as b on b.groupid = a.groupid where a.groupid <>'0' and b.flag = 1 group by a.groupid union select max(a.createtime) as createtime,a.friendid,a.groupid,b.flag as groupflg,a.imgpath,a.friendname,a.content from message_master a left join groupmaster as b on b.groupid = a.groupid where a.groupid <>'0' and b.flag = 0 group by a.groupid union select max(createtime) as createtime,friendid,'0' as groupid,'0' as groupflg,imgpath,friendname,content from message_master where groupid ='0' group by friendid) where createtime > ? order by createtime desc"]UTF8String];
    //金融机构经理人身份
    if ([PBUserModel getPasswordAndKind].kind != 2) {
        sql = [[NSString stringWithFormat:@"%@",@"select createtime,friendid,groupid,groupflg,imgpath,friendname,content from (select max(a.createtime) as createtime,a.friendid,a.groupid,b.flag as groupflg,a.imgpath,a.friendname,a.content from message_master a left join groupmaster as b on b.groupid = a.groupid where a.groupid <>'0' and b.flag = 1 group by a.groupid union select max(a.createtime) as createtime,a.friendid,a.groupid,b.flag as groupflg,a.imgpath,a.friendname,a.content from message_master a left join groupmaster as b on b.groupid = a.groupid where a.groupid =? group by a.friendid union select max(a.createtime) as createtime,a.friendid,a.groupid,b.flag as groupflg,a.imgpath,a.friendname,a.content from message_master a left join groupmaster as b on b.groupid = a.groupid where a.groupid <>'0' and b.flag = 0 group by a.groupid union select max(createtime) as createtime,friendid,'0' as groupid,'0' as groupflg,imgpath,friendname,content from message_master where groupid ='0' group by friendid) where createtime > ? order by createtime desc"]UTF8String];
    }
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        //只保留一周的会话数据
        int seconds = 7*24*60*60;
        sqlite3_bind_int(stmt, 1, [[NSDate date] timeIntervalSince1970]-seconds);
        if ([PBUserModel getPasswordAndKind].kind != 2) {
            sqlite3_bind_int(stmt, 1, [PBUserModel getCompanyno]);
            sqlite3_bind_int(stmt, 2, [[NSDate date] timeIntervalSince1970]-seconds);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAMessageData* data = [[FAMessageData alloc]init];
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 0)];
            data.friendid = (int)sqlite3_column_int(stmt, 1);
            data.groupid = (int)sqlite3_column_int(stmt, 2);
            data.groupflg = (int)sqlite3_column_int(stmt, 3);
            char* cName = (char*)sqlite3_column_text(stmt, 4);
            if (cName)
                data.imgpath= [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 5);
            if (cName)
                data.friendname = [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 6);
            if (cName)
                data.content = [NSString stringWithUTF8String:cName];
            data.count = [self getUnreadContentCountByGId:data.groupid friendid:data.friendid groupflg:data.groupflg];
            data.actionflg = [self getActionflgByGId:data.groupid];
            [listData   addObject:data];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return listData;
}
+(int)getActionflgByGId:(int)gid{
    int actionflg = 0;
    sqlite3_stmt *stmt = nil;
    const char *friendsql = [[NSString stringWithFormat:@"%@",@"select actionflg from message_master where groupid = ? and whosaid=1 "]UTF8String];
    const char *sql = friendsql;
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, gid);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            actionflg = (int)sqlite3_column_int(stmt, 0);
            
            break;
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    
    return actionflg;
}
@end
