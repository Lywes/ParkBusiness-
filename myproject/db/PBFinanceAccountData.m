//
//  PBFinanceAccountData.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceAccountData.h"
static sqlite3* database = nil;
@implementation PBFinanceAccountData
@synthesize activitycashflow,aftertaxprofit,assetamount,assetdebtrate,netasset,no,others,pretaxprofit,projectno,responseamount,salesrevenue,year,type;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}

+(NSMutableArray*)searchData:(int)projectno withyear:(int)year withType:(int)type
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,projectno,	year,assetamount,responseamount,netasset,assetdebtrate,salesrevenue,pretaxprofit,aftertaxprofit,activitycashflow,others from financingleaseaccount where projectno = ? and year >= ? and type = ? order by year desc"]UTF8String];
    const char *allsql = [[NSString stringWithFormat:@"%@",@"select no,projectno,	year,assetamount,responseamount,netasset,assetdebtrate,salesrevenue,pretaxprofit,aftertaxprofit,activitycashflow,others from financingleaseaccount order by year desc"]UTF8String];
    if (projectno<=0) {
        sql = allsql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if (projectno>0) {
            sqlite3_bind_int(stmt, 1, projectno);
            sqlite3_bind_int(stmt, 2, year);
            sqlite3_bind_int(stmt, 3, type);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBFinanceAccountData* data = [[[PBFinanceAccountData alloc]init] autorelease];
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.projectno = (int)sqlite3_column_int(stmt, 1);
            data.year = (int)sqlite3_column_int(stmt, 2);
            data.assetamount = (int)sqlite3_column_int(stmt, 3);
            data.responseamount = (int)sqlite3_column_int(stmt, 4);
            data.netasset = (int)sqlite3_column_int(stmt, 5);
            data.assetdebtrate = (int)sqlite3_column_int(stmt, 6);
            data.salesrevenue = (int)sqlite3_column_int(stmt, 7);
            data.pretaxprofit = (int)sqlite3_column_int(stmt, 8);
            data.aftertaxprofit = (int)sqlite3_column_int(stmt, 9);
            data.activitycashflow = (int)sqlite3_column_int(stmt, 10);
            char* others = (char*)sqlite3_column_text(stmt, 11);
            if (others)
                data.others = [NSString stringWithUTF8String:others];
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

+(int)saveId:(int)no
        type:(int)type
   projectno:(int)projectno
   year:(int)year
    assetamount:(int)assetamount
    responseamount:(int)responseamount
 netasset:(int)netasset
  assetdebtrate:(int)assetdebtrate
 salesrevenue:(int)salesrevenue
   pretaxprofit:(int)pretaxprofit
aftertaxprofit:(int)aftertaxprofit
activitycashflow:(int)activitycashflow
others:(NSString*)others
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into financingleaseaccount(no,projectno,	year,assetamount,responseamount,netasset,assetdebtrate,salesrevenue,pretaxprofit,aftertaxprofit,activitycashflow,others,cdate,udate,type) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 3, year);
    sqlite3_bind_int(stmt, 4, assetamount);
    sqlite3_bind_int(stmt, 5, responseamount);
    sqlite3_bind_int(stmt, 6, netasset);
    sqlite3_bind_int(stmt, 7, assetdebtrate);
    sqlite3_bind_int(stmt, 8, salesrevenue);
    sqlite3_bind_int(stmt, 9, pretaxprofit);
    sqlite3_bind_int(stmt, 10, aftertaxprofit);
    sqlite3_bind_int(stmt, 11, activitycashflow);
    sqlite3_bind_text(stmt, 12, [others UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 13, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 14, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 15, type);
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
    no = [PBFinanceAccountData saveId:self.no type:self.type projectno:self.projectno year:self.year assetamount:self.assetamount responseamount:self.responseamount netasset:self.netasset assetdebtrate:self.assetdebtrate salesrevenue:self.salesrevenue pretaxprofit:self.pretaxprofit aftertaxprofit:self.aftertaxprofit activitycashflow:self.activitycashflow others:self.others];
}

+(void)deleteWithProjectno:(int)recordId withType:(int)type_
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"delete from financingleaseaccount where projectno = ? and type = ? " UTF8String];
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
    sqlite3_bind_int(stmt, 2, type_);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    
}
@end
