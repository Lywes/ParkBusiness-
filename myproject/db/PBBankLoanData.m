//
//  PBBankLoanData.m
//  ParkBusiness
//
//  Created by QDS on 13-5-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBankLoanData.h"
static sqlite3* database = nil;
@implementation PBBankLoanData
@synthesize no;
@synthesize projectno;
@synthesize securedform;
@synthesize applyloan;
@synthesize yearraterange;
@synthesize loanlimit;
@synthesize loanuse;
@synthesize others;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}

+(PBBankLoanData*)searchData:(int)projectno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,projectno,securedform,applyloan,loanlimit,yearraterange,loanuse,others from bankloaninfo where projectno = ?"]UTF8String];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBBankLoanData* data = [[[PBBankLoanData alloc]init] autorelease];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, projectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.projectno = (int)sqlite3_column_int(stmt, 1);
            data.securedform = (int)sqlite3_column_int(stmt, 2);
            data.applyloan = (int)sqlite3_column_int(stmt, 3);
            data.loanlimit = (int)sqlite3_column_int(stmt, 4);
            data.yearraterange = (int)sqlite3_column_int(stmt, 5);
            data.loanuse = (int)sqlite3_column_int(stmt, 6);
            char* str = (char*)sqlite3_column_text(stmt, 7);
            if (str){
                data.others = [NSString stringWithUTF8String:str];
            }
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return data;
}

+(int)saveId:(int)no
      projectno:(int)projectno
    securedform:(int)securedform
   applyloan:(int)applyloan
   loanlimit:(int)loanlimit
yearraterange:(int)yearraterange
 loanuse:(int)loanuse
others:(NSString*)others
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into bankloaninfo(no,projectno,securedform,applyloan,loanlimit,yearraterange,loanuse,others,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 3, securedform);
    sqlite3_bind_int(stmt, 4, applyloan);
    sqlite3_bind_int(stmt, 5, loanlimit);
    sqlite3_bind_int(stmt, 6, yearraterange);
    sqlite3_bind_int(stmt, 7, loanuse);
    sqlite3_bind_text(stmt, 8, [others UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 10, [[NSDate date] timeIntervalSince1970]);
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
    no = [PBBankLoanData saveId:self.no projectno:self.projectno securedform:self.securedform applyloan:self.applyloan loanlimit:self.loanlimit yearraterange:self.yearraterange loanuse:self.loanuse others:self.others];
}


@end
