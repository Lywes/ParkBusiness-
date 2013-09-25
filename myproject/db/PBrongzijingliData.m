//
//  PBtrendData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBrongzijingliData.h"
static sqlite3* database = nil;
@implementation PBrongzijingliData
@synthesize no,projectno,invsetstage,invsetamount,amountunit,financetime,investors;

-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)searchWhereProjectno:(int)projectno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,projectno,investstage,investamount,amountunit,financetime,investors from investexperience where projectno = ?"]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, projectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBrongzijingliData* data = [[[PBrongzijingliData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);            
            data.projectno = (int)sqlite3_column_int(stmt, 1);
            data.invsetstage = (int)sqlite3_column_int(stmt, 2);
            
            char* invsetamount = (char*)sqlite3_column_text(stmt, 3);
            if (invsetamount)
            {
                data.invsetamount = [NSString stringWithUTF8String:invsetamount];
            }

            data.amountunit = (int)sqlite3_column_int(stmt, 4);
            
            char* financetime = (char*)sqlite3_column_text(stmt, 5);
            if (financetime)
                data.financetime = [NSString stringWithUTF8String:financetime];
            
            char* investors = (char*)sqlite3_column_text(stmt, 6);
            if (investors)
                data.investors = [NSString stringWithUTF8String:investors];

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
   projectno:(int)projectno 
 invsetstage:(int)invsetstage
invsetamount:(NSString *)invsetamount 
  amountunit:(int)amountunit
 financetime:(NSString *)financetime 
   investors:(NSString *)investors
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into investexperience(no,projectno,investstage,investamount,amountunit,financetime,investors) Values(?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 3, invsetstage);
    sqlite3_bind_text(stmt, 4, [invsetamount UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, amountunit);
    sqlite3_bind_text(stmt, 6, [financetime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 7, [investors UTF8String], -1, SQLITE_TRANSIENT);

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
    no = [PBrongzijingliData SaveId:self.no projectno:self.projectno invsetstage:self.invsetstage invsetamount:self.invsetamount amountunit:self.amountunit financetime:self.financetime investors:self.investors];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from investexperience where no = ?  ";
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
