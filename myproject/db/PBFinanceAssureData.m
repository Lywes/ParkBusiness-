//
//  PBFinanceAssureData.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceAssureData.h"
static sqlite3* database = nil;
@implementation PBFinanceAssureData
@synthesize no;
@synthesize loanapply;
@synthesize applycredituse;
@synthesize enterprise;
@synthesize creditamount;
@synthesize creditlimit;
@synthesize repaytype;
@synthesize loanbankname;
@synthesize applyproperty;
@synthesize assurerate;
+(PBFinanceAssureData*)searchData:(int)no
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,loanapply,applyproperty,enterprise,creditamount,creditlimit,repaytype,loanbankname,applycredituse,assurerate from financingassure where no = ?"]UTF8String];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBFinanceAssureData* data = [[[PBFinanceAssureData alloc]init] autorelease];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, no);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data.no = (int)sqlite3_column_int(stmt, 0);
            char* loanapply = (char*)sqlite3_column_text(stmt, 1);
            if (loanapply)
                data.loanapply = [NSString stringWithUTF8String:loanapply];
            data.applyproperty = (int)sqlite3_column_int(stmt, 2);
            char* enterprise = (char*)sqlite3_column_text(stmt, 3);
            if (enterprise)
                data.enterprise = [NSString stringWithUTF8String:enterprise];
            data.creditamount = (int)sqlite3_column_int(stmt, 4);
            data.creditlimit = (int)sqlite3_column_int(stmt, 5);
            data.repaytype = (int)sqlite3_column_int(stmt, 6);
            char* loanbankname = (char*)sqlite3_column_text(stmt, 7);
            if (loanbankname)
                data.loanbankname = [NSString stringWithUTF8String:loanbankname];
            data.applycredituse = (int)sqlite3_column_int(stmt, 8);
            data.assurerate = (int)sqlite3_column_int(stmt, 9);
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
    loanapply:(NSString*)loanapply
   applyproperty:(int)applyproperty
   enterprise:(NSString*)enterprise
        creditamount:(int)creditamount
        creditlimit:(int)creditlimit
        repaytype:(int)repaytype
        loanbankname:(NSString*)loanbankname
    applycredituse:(int)applycredituse
    assurerate:(int)assurerate
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into financingassure(no,loanapply,applyproperty,enterprise,creditamount,creditlimit,repaytype,loanbankname,applycredituse,assurerate,imagepath,companyno,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
     sqlite3_bind_text(stmt, 2, [loanapply UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, applyproperty);
     sqlite3_bind_text(stmt, 4, [enterprise UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, creditamount);
    sqlite3_bind_int(stmt, 6, creditlimit);
    sqlite3_bind_int(stmt, 7, repaytype);
    sqlite3_bind_text(stmt, 8, [loanbankname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, applycredituse);
    sqlite3_bind_int(stmt, 10, assurerate);
    NSData *imageData;
    UIImage* image = [UIImage imageNamed:@"boss.png"];
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 11, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 12, [PBUserModel getCompanyno]);
    sqlite3_bind_int(stmt, 13, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 14, [[NSDate date] timeIntervalSince1970]);
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
    no = [PBFinanceAssureData saveId:self.no loanapply:self.loanapply applyproperty:self.applyproperty enterprise:self.enterprise creditamount:self.creditamount creditlimit:self.creditlimit repaytype:self.repaytype loanbankname:self.loanbankname applycredituse:self.applycredituse assurerate:self.assurerate];
}
+(void)deleteRecord:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"delete from financingassure where no = ? " UTF8String];
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
