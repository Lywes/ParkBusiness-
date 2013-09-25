//
//  PBKbnMasterData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBKbnMasterModel.h"

static sqlite3* database = nil;

@implementation PBKbnMasterModel
@synthesize  recordId;
@synthesize  kind;
@synthesize  name;
-(id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}
+(NSMutableArray*)getKbnInfoByKind:(NSString*)kind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select id,name from kbn_master where kind = ? order by id "]UTF8String];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return arr;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [kind UTF8String],-1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBKbnMasterModel* model = [[PBKbnMasterModel alloc]init];
            model.recordId  = (int)sqlite3_column_int(stmt, 0);
            char* cName = (char*)sqlite3_column_text(stmt,1);
            if (cName)
                model.name = [NSString stringWithUTF8String:cName];
            [arr addObject:model];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return arr;
}


+(NSString*)getKbnNameById:(int)recordId withKind:(NSString*)kind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select name from kbn_master where kind = ? and id = ?"]UTF8String];
    NSString* name = @"";
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return @"";
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [kind UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_int(stmt, 2, recordId);   
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char* cName = (char*)sqlite3_column_text(stmt,0);
            if (cName)
                name = [NSString stringWithUTF8String:cName];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return name;
}

+(int)getKbnIdByName:(NSString*)name withKind:(NSString*)kind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select id from kbn_master where kind = ? and name = ?"]UTF8String];
    int recordId = -1;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return recordId;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [kind UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(stmt, 2, [name UTF8String],-1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            recordId = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return recordId;
}
+(int)saveId:(int)recordId
        name:(NSString*)name
        kind:(NSString*)kind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    // NSLog(dbPath);
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert into kbn_master(kind,id,name) Values(?,?,?)"]UTF8String];
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
    
    sqlite3_bind_text(stmt, 1, [kind UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 2, recordId);
    sqlite3_bind_text(stmt, 3, [name UTF8String],-1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(stmt)) 
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        recordId = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return recordId;
}
+(void)deleteAllRecord
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from kbn_master ";
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
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    
}


-(void)saveRecord
{
    recordId = [PBKbnMasterModel saveId:recordId name:name kind:kind];
}
-(void)deleteRecord
{
    [PBKbnMasterModel deleteAllRecord];
}



@end