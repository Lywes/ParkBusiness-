//
//  FAInviteInfoData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAInviteInfoData.h"
static sqlite3* database = nil;
@implementation FAInviteInfoData
@synthesize no,fromid,alert,kind,username,groupid,groupname,flg;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)search:(int)no
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from inviteinfo where flg = 0 order by id desc "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from inviteinfo where id is ?  "]UTF8String];
    
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (no != -1) {
        sql = noSearchSql;
    }

    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(no!=-1){
            sqlite3_bind_int(stmt, 1, no);
        }
        
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAInviteInfoData* data = [[FAInviteInfoData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            data.fromid = (int)sqlite3_column_int(stmt, 1);
            
            char* cName = (char*)sqlite3_column_text(stmt, 2);
            if (cName)
                data.alert = [NSString stringWithUTF8String:cName];
            
            data.kind = (int)sqlite3_column_int(stmt, 3);
            
            cName = (char*)sqlite3_column_text(stmt, 4);
            if (cName)
                data.username = [NSString stringWithUTF8String:cName];
            
            data.groupid = (int)sqlite3_column_int(stmt, 5);
            
            cName = (char*)sqlite3_column_text(stmt, 6);
            if (cName)
                data.groupname = [NSString stringWithUTF8String:cName];
            
            data.flg = (int)sqlite3_column_int(stmt, 7);
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
      fromid:(int)fromid
       alert:(NSString*)alert
        kind:(int)kind
    username:(NSString*)username
     groupid:(int)groupid
   groupname:(NSString*)groupname
         flg:(int)flg
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into inviteinfo(id,fromid,alert,kind,username,groupid,groupname,flg",@") Values(?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, fromid);
    sqlite3_bind_text(stmt, 3, [alert UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, kind);
    sqlite3_bind_text(stmt, 5, [username UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, groupid);
    sqlite3_bind_text(stmt, 7, [groupname UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 8, flg);
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
    no = [FAInviteInfoData saveId:self.no
                           fromid:self.fromid
                            alert:self.alert
                             kind:self.kind
                         username:self.username
                          groupid:self.groupid
                        groupname:self.groupname
                              flg:self.flg];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from inviteinfo where id = ? ";
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
    [FAInviteInfoData deleteId:self.no];
}
@end
