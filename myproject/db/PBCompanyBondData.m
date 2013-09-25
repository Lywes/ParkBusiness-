//
//  PBCompanyBondData.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBCompanyBondData.h"
static sqlite3* database = nil;
@implementation PBCompanyBondData
@synthesize no;
@synthesize bondamount;
@synthesize issueamount;
@synthesize bondtype;
@synthesize yearprofit;
@synthesize debttoequity;
@synthesize others;
+(PBCompanyBondData*)searchData:(int)no
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,bondtype,issueamount,bondamount,yearprofit,debttoequity,others from companybondinfo where no = ?"]UTF8String];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBCompanyBondData* data = [[[PBCompanyBondData alloc]init] autorelease];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, no);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.bondtype = (int)sqlite3_column_int(stmt, 1);
            data.issueamount = (int)sqlite3_column_int(stmt, 2);
            data.bondamount = (int)sqlite3_column_int(stmt, 3);
            data.yearprofit = (int)sqlite3_column_int(stmt, 4);
            data.debttoequity = (int)sqlite3_column_int(stmt, 5);
            char* others = (char*)sqlite3_column_text(stmt, 6);
            if (others)
                data.others = [NSString stringWithUTF8String:others];
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
bondtype:(int)bondtype
issueamount:(int)issueamount
 bondamount:(int)bondamount
   yearprofit:(int)yearprofit
debttoequity:(int)debttoequity
others:(NSString*)others
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into companybondinfo(no,companyno,imagepath,bondtype,issueamount,bondamount,yearprofit,debttoequity,others,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 4, bondtype);
    sqlite3_bind_int(stmt, 5, issueamount);
    sqlite3_bind_int(stmt, 6, bondamount);
    sqlite3_bind_int(stmt, 7, yearprofit);
    sqlite3_bind_int(stmt, 8, debttoequity);
    sqlite3_bind_text(stmt, 9, [others UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 10, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 11, [[NSDate date] timeIntervalSince1970]);
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
    no = [PBCompanyBondData saveId:self.no bondtype:self.bondtype issueamount:self.issueamount bondamount:self.bondamount yearprofit:self.yearprofit debttoequity:self.debttoequity others:self.others];
}

+(void)deleteRecord:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"delete from companybondinfo where no = ? " UTF8String];
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
