//
//  DBFinancingCase.m
//  ParkBusiness
//
//  Created by China on 13-8-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "DBFinancingCase.h"
static sqlite3* database = nil;
@implementation DBFinancingCase
@synthesize no;
@synthesize userno;
@synthesize projectno;
@synthesize productno;
@synthesize companyno;
@synthesize type;
@synthesize name;
@synthesize casedetail;
@synthesize trade;
@synthesize companyinfo;

-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)search
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,userno,projectno,productno,companyno,type,name,casedetail,trade,companyinfo from bankfinancingcase "]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            DBFinancingCase* data = [[[DBFinancingCase alloc]init] autorelease];
            data.no = (int)sqlite3_column_int(stmt, 0);
            data.userno = (int)sqlite3_column_int(stmt, 1);
             data.projectno = (int)sqlite3_column_int(stmt, 2);
            data.productno = (int)sqlite3_column_int(stmt, 3);
             data.companyno = (int)sqlite3_column_int(stmt, 4);
             data.type = (int)sqlite3_column_int(stmt, 5);
            char* condition = (char*)sqlite3_column_text(stmt, 6);
            if (condition)
                data.name = [NSString stringWithUTF8String:condition];
            
            char* cdate = (char*)sqlite3_column_text(stmt, 7);
            if (cdate)
                data.casedetail = [NSString stringWithUTF8String:cdate];
            
            data.trade = (int)sqlite3_column_int(stmt, 8);
            
            char* companyinfo = (char*)sqlite3_column_text(stmt, 9);
            if (companyinfo)
                data.companyinfo = [NSString stringWithUTF8String:companyinfo];
            
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
      userno:(int)userno
   projectno:(int)projectno
   productno:(int)productno
   companyno:(int)companyno
        type:(int)type
       trade:(int)trade
 companyinfo:(NSString *)companyinfo
        name:(NSString *)name
  casedetail:(NSString *)casedetail
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into bankfinancingcase(no,userno,projectno,productno,companyno,type,trade,companyinfo,name,casedetail) Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, userno);
    sqlite3_bind_int(stmt, 3, projectno);
    sqlite3_bind_int(stmt, 4, productno);
    sqlite3_bind_int(stmt, 5, companyno);
    sqlite3_bind_int(stmt, 6, type);
    sqlite3_bind_int(stmt, 7, trade);
    sqlite3_bind_text(stmt, 8, [companyinfo UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 9, [name UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(stmt, 10, [casedetail UTF8String], -1, SQLITE_TRANSIENT);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
    
}
-(void)save
{
   no =  [DBFinancingCase SaveId:self.no userno:self.userno projectno:self.productno productno:self.productno companyno:self.companyno type:self.type trade:self.trade companyinfo:self.companyinfo name:self.name casedetail:self.casedetail];
}
@end
