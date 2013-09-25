//
//  FAGroupMemberData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAGroupMemberData.h"
#import "FAUserData.h"
static sqlite3* database = nil;
@implementation FAGroupMemberData
@synthesize no,groupid,userid,username,createtime;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)search:(int)gid
                   limit:(int)limitNumber
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from groupmember order by id desc "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmember where groupid is ?  and userid <> ?"]UTF8String];
    
    const char *limitSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmember where groupid is ?  and userid <> ? order by id desc limit ?,25"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (gid != -1) {
        sql = noSearchSql;
    }

    if (limitNumber >= 0) {
        sql = limitSearchSql;
    }
    FAUserData *user = [FAUserData search];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(gid!=-1){
            sqlite3_bind_int(stmt, 1, gid);
            sqlite3_bind_int(stmt, 2, user.no);
        }
        if(limitNumber!=-1){
            sqlite3_bind_int(stmt, 1, gid);
            sqlite3_bind_int(stmt, 2, user.no);
            sqlite3_bind_int(stmt, 3, limitNumber);
        }

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAGroupMemberData* data = [[FAGroupMemberData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            data.groupid = (int)sqlite3_column_int(stmt, 1);
            
            data.userid = (int)sqlite3_column_int(stmt, 2);
            
            char* cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.username = [NSString stringWithUTF8String:cName];
            
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 4)];
            
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
+(BOOL)isGroupMember:(int)groupid byuser:(int)userid{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select count(groupid) from groupmember where groupid =? and userid =?"]UTF8String];
    int count=0;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, groupid);
        sqlite3_bind_int(stmt, 2, userid);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            count = (int)sqlite3_column_int(stmt, 0);
            
            
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    if (count >0) {
        return YES;
    }
    return NO;
}
+(int)saveId:(int)no
     groupid:(int)groupid
      userid:(int)userid
    username:(NSString*)username
  createtime:(NSDate*)createtime
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into groupmember(id,groupid,userid,username,createtime",@") Values(?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, groupid);
    sqlite3_bind_int(stmt, 3, userid);
    sqlite3_bind_text(stmt, 4, [username UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, [createtime timeIntervalSince1970]);
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
    if ((self.no==-1 && ![FAGroupMemberData isGroupMember:self.groupid byuser:self.userid]) || (self.no>0)) {
        self.no = [FAGroupMemberData saveId:self.no groupid:self.groupid userid:self.userid username:self.username createtime:self.createtime];
    }
    
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from groupmaster where id = ? ";
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
    [FAGroupMemberData deleteId:self.no];
}
@end
