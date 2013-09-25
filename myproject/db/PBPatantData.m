//
//  PBPatantData.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPatantData.h"
static sqlite3* database = nil;
@implementation PBPatantData
@synthesize projectno;
@synthesize acceptdate;
@synthesize authorizedate;
@synthesize name;
@synthesize no;
@synthesize patentno;
@synthesize type;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}

+(NSMutableArray*)searchData:(int)projectno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,projectno,type,name,patentno,acceptdate,authorizedate from patentinfo where projectno = ?"]UTF8String];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    NSMutableArray* listArr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, projectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBPatantData* data = [[[PBPatantData alloc]init] autorelease];
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.projectno = (int)sqlite3_column_int(stmt, 1);
            data.type = (int)sqlite3_column_int(stmt, 2);
            char* name = (char*)sqlite3_column_text(stmt, 3);
            if (name)
                data.name = [NSString stringWithUTF8String:name];
            char* patentno = (char*)sqlite3_column_text(stmt, 4);
            if (patentno)
                data.patentno = [NSString stringWithUTF8String:patentno];
            data.acceptdate = (int)sqlite3_column_int(stmt, 5)==0?@"":[NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 5)];
            data.authorizedate = (int)sqlite3_column_int(stmt, 6)==0?@"":[NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 6)];
            [listArr addObject:data];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return listArr;
}

+(int)saveId:(int)no
   projectno:(int)projectno
   type:(int)type
    name:(NSString*)name
    patentno:(NSString*)patentno
 acceptdate:(NSDate*)acceptdate
  authorizedate:(NSDate*)authorizedate
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into patentinfo(no,projectno,type,name,patentno,acceptdate,authorizedate,cdate,udate) Values(?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, projectno);
    sqlite3_bind_int(stmt, 3, type);
    sqlite3_bind_text(stmt, 4, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [patentno UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, [acceptdate timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 7, [authorizedate timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 8, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 9, [[NSDate date] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}


-(void)saveRecord
{
    no = [PBPatantData saveId:self.no projectno:self.projectno type:self.type name:self.name patentno:self.patentno acceptdate:self.acceptdate authorizedate:self.authorizedate];
}
+(void)deleteRecord:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"delete from patentinfo where no = ? " UTF8String];
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
