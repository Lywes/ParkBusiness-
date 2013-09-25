//
//  FAFriendGroupData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAFriendGroupData.h"
static sqlite3* database = nil;
@implementation FAFriendGroupData
@synthesize no,name,idx,flag;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}

+(NSMutableArray*)search:(int)no
                    name:(NSString*)name
                   limit:(int)limitNumber
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from friendgroup order by idx  "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friendgroup where id is ?  "]UTF8String];
    const char *titleSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friendgroup where name like ? order by idx  "]UTF8String];
    const char *limitSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friendgroup order by idx  limit ?,10"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (no >0) {
        sql = noSearchSql;
    }
    if(name){
        sql = titleSearchSql;
    }
    if (limitNumber >= 0) {
        sql = limitSearchSql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(no>0){
            sqlite3_bind_int(stmt, 1, no);
        }
        if(limitNumber!=-1){
            sqlite3_bind_int(stmt, 1, limitNumber);
        }
        if(name){
            NSString* likeName = [NSString stringWithFormat:@"%@%%",name];
            sqlite3_bind_text(stmt, 1, [likeName UTF8String], -1, SQLITE_TRANSIENT);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAFriendGroupData* data = [[FAFriendGroupData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            
            
            char* cName = (char*)sqlite3_column_text(stmt, 1);
            if (cName)
                data.name = [NSString stringWithUTF8String:cName];
            
                        
            data.idx = (int)sqlite3_column_int(stmt, 2);
            
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

+(BOOL)checkGroupNameExist:(NSString*)name
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select count(*) from friendgroup where name = ? order by idx  "]UTF8String];
    BOOL check = TRUE;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return check;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
          int count = (int)sqlite3_column_int(stmt, 0);
            check = count==0?FALSE:TRUE;
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return check;
}

+(NSMutableArray*)searchGroupInfoWithFriendId:(int)no
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@" select a.* ,b.no from friendgroup a  left join friendgroupmember as b on a.id = b.fgid and b.fid = ? where a.idx > 2 order by a.idx"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(no>0){
            sqlite3_bind_int(stmt, 1, no);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAFriendGroupData* data = [[FAFriendGroupData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* cName = (char*)sqlite3_column_text(stmt, 1);
            if (cName)
                data.name = [NSString stringWithUTF8String:cName];
            
            data.idx = (int)sqlite3_column_int(stmt, 2);
            
            data.flag = [NSString stringWithFormat:@"%d",(int)sqlite3_column_int(stmt, 3)];
            
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

+(int)searchMaxIdx
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select max(idx) from friendgroup"]UTF8String];
    int idx = -1;
    // [listData retain];
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return idx;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            idx = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return idx;
}

+(int)saveId:(int)no
        name:(NSString*)name
         idx:(int)idx
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into friendgroup(id,name,idx",@") Values(?,?,?)"]UTF8String];
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
    
    sqlite3_bind_text(stmt, 2, [name UTF8String],-1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(stmt, 3, idx);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

+(void)saveFriendGroupMemberInfo:(int)no fid:(int)fid fgid:(int)fgid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into friendgroupmember(no,fid,fgid",@") Values(?,?,?)"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    if (no == -1||no == 0) {
        
    }else{
        sqlite3_bind_int(stmt, 1, no);
    }
    sqlite3_bind_int(stmt, 2, fid);
    sqlite3_bind_int(stmt, 3, fgid);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+(int)exchangeFromNo:(NSUInteger)no toIdx:(NSUInteger)toIdx
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update friendgroup set idx = ? where id = ?"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, toIdx);
    
    sqlite3_bind_int(stmt, 2, no);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return toIdx;
}

-(void)saveRecord
{
    no = [FAFriendGroupData saveId:self.no name:self.name idx:self.idx];
}

+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from friendgroup where id = ? ";
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
+(void)deleteFriendGroupMemberWithFid:(int)fid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from friendgroupmember where fid = ? ";
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
    sqlite3_bind_int(stmt, 1, fid);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    
}
-(void)deleteRecord
{
    [FAFriendGroupData deleteId:self.no];
}
@end
