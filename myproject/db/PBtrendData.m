//
//  PBtrendData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtrendData.h"
static sqlite3* database = nil;

@implementation PBtrendData
@synthesize no,projectno,condition,cdate;

-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)searchByprojectno:(int)prjectno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,projectno,condition,cdate from projectcondition where projectno = ?"]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, prjectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBtrendData* data = [[[PBtrendData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);            
            data.projectno = (int)sqlite3_column_int(stmt, 1);
            char* condition = (char*)sqlite3_column_text(stmt, 2);
            if (condition)
                data.condition = [NSString stringWithUTF8String:condition];
            
            char* cdate = (char*)sqlite3_column_text(stmt, 3);
            if (cdate)
                data.cdate = [NSString stringWithUTF8String:cdate];
            [listData addObject:data];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return listData;
    
}
+(int)SaveId:(int)no 
    prjectno:(int)projectno
   condition:(NSString *)condition
       cdate:(NSString *)cdate
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectcondition(no,projectno,condition,cdate) Values(?,?,?,?)"]UTF8String];
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
    if (no == -1|| no == 0) {
        
    }else{
        sqlite3_bind_int(stmt, 1, no);
    }
    sqlite3_bind_int(stmt, 2, projectno);
    sqlite3_bind_text(stmt, 3, [condition UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [cdate UTF8String], -1, SQLITE_TRANSIENT);
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
    no = [PBtrendData SaveId:self.no prjectno:self.projectno condition:self.condition cdate:self.cdate];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from projectcondition where no = ?  ";
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
@end
