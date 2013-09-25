//
//  FASystemMessageData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FASystemMessageData.h"
static sqlite3* database = nil;
@implementation FASystemMessageData
@synthesize no,isread,object,formatid,content,createtime;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)search:(int)no
                   limit:(int)limitNumber
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from system_message order by createtime desc "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from system_message where id is ?  "]UTF8String];
    
    const char *limitSearchSql = [[NSString stringWithFormat:@"%@",@"select * from system_message where isread=0 order by createtime desc limit ?,25"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (no != -1) {
        sql = noSearchSql;
    }
    
    if (limitNumber >= 0) {
        sql = limitSearchSql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(no!=-1){
            sqlite3_bind_int(stmt, 1, no);
        }
        if(limitNumber!=-1){
            sqlite3_bind_int(stmt, 1, limitNumber);
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FASystemMessageData* data = [[FASystemMessageData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            data.isread = (int)sqlite3_column_int(stmt, 1);
            
            char* cName = (char*)sqlite3_column_text(stmt, 2);
            if (cName)
                data.object = [NSString stringWithUTF8String:cName];
            
            data.formatid = (int)sqlite3_column_int(stmt, 3);
            
            cName = (char*)sqlite3_column_text(stmt, 4);
            if (cName)
                data.content = [NSString stringWithUTF8String:cName];
            
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 5)];
            
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
      isread:(int)isread
      object:(NSString*)object
    formatid:(int)formatid
     content:(NSString*)content
  createtime:(NSDate*)createtime
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into system_message(id,isread,object,formatid,content,createtime",@") Values(?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, isread);
    sqlite3_bind_text(stmt, 3, [object UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, formatid);
    sqlite3_bind_text(stmt, 5, [content UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, [createtime timeIntervalSince1970]);
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
    no = [FASystemMessageData saveId:self.no
                              isread:self.isread
                              object:self.object
                            formatid:self.formatid
                             content:self.content
                          createtime:self.createtime];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from system_message where id = ? ";
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
    [FASystemMessageData deleteId:self.no];
}
+(void)updateIsreadFlgByNo:(int)no limitFlg:(BOOL)flg{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allUpdateSql = [[NSString stringWithFormat:@"%@",@"update system_message set isread=1 "]UTF8String];
    const char *noUpdateSql = [[NSString stringWithFormat:@"%@",@"update system_message set isread=1 where id is ?  "]UTF8String];
    
    const char *limitUpdateSql = [[NSString stringWithFormat:@"%@",@"update system_message set isread=1 where isread=0 and no <= ?"]UTF8String];
    const char *sql = allUpdateSql;
    if (flg) {
        sql = limitUpdateSql;
    }else{
        if (no>0) {
            sql = noUpdateSql;
        }
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
    if (flg) {
        sqlite3_bind_int(stmt, 1, no);
    }else{
        if (no>0) {
            sqlite3_bind_int(stmt, 1, no);
        }
    }
    sqlite3_bind_int(stmt, 1, no);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }

}
@end
