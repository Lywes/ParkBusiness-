//
//  PBFinanceLeaseData.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceLeaseData.h"
static sqlite3* database = nil;
@implementation PBFinanceLeaseData
@synthesize no;
@synthesize type;
@synthesize projectamount;
@synthesize receiptfund;
@synthesize leasedeviceinfo;
+(PBFinanceLeaseData*)searchData:(int)no
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,type,projectamount,receiptfund,leasedeviceinfo from financinglease where no = ?"]UTF8String];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBFinanceLeaseData* data = [[[PBFinanceLeaseData alloc]init] autorelease];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, no);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.type = (int)sqlite3_column_int(stmt, 1);
            data.projectamount = (int)sqlite3_column_int(stmt, 2);
            data.receiptfund = (int)sqlite3_column_int(stmt, 3);
            char* leasedeviceinfo = (char*)sqlite3_column_text(stmt, 4);
            if (leasedeviceinfo)
                data.leasedeviceinfo = [NSString stringWithUTF8String:leasedeviceinfo];
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
    type:(int)type
 projectamount:(int)projectamount
  receiptfund:(int)receiptfund
      leasedeviceinfo:(NSString*)leasedeviceinfo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into financinglease(no,companyno,imagepath,type,projectamount,receiptfund,leasedeviceinfo,cdate,udate) Values(?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, [PBUserModel getCompanyno]);
    NSData *imageData;
    UIImage* image = [UIImage imageNamed:@"boss.png"];
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 3, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 4, type);
    sqlite3_bind_int(stmt, 5, projectamount);
    sqlite3_bind_int(stmt, 6, receiptfund);
    sqlite3_bind_text(stmt, 7, [leasedeviceinfo UTF8String], -1, SQLITE_TRANSIENT);
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
    no = [PBFinanceLeaseData saveId:self.no type:self.type projectamount:self.projectamount receiptfund:self.receiptfund leasedeviceinfo:self.leasedeviceinfo];
}
+(void)deleteRecord:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"delete from financinglease where no = ? " UTF8String];
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
