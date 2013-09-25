//
//  PBPlanData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPlanData.h"
static sqlite3* database = nil;
@implementation PBPlanData
@synthesize no,stdate,enddate,totalbudget,salestarget,profittarget,teambiulding,productdev,projectno,companyno;
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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,stdate,enddate,totalbudget,salestarget,profittarget,teambiulding,productdev,projectno,companyno from projectplan  where projectno = ?"]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    // [listData retain];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, projectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBPlanData* data = [[[PBPlanData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* stdate = (char*)sqlite3_column_text(stmt, 1);
            if (stdate)
                data.stdate = [NSString stringWithUTF8String:stdate];
          
            char* enddate = (char*)sqlite3_column_text(stmt, 2);
            if (enddate)
                data.enddate = [NSString stringWithUTF8String:enddate];
            
            char* totalbudget = (char*)sqlite3_column_text(stmt, 3);
            if (totalbudget)
                data.totalbudget = [NSString stringWithUTF8String:totalbudget];
            
            char* salestarget = (char*)sqlite3_column_text(stmt, 4);
            if (salestarget)
                data.salestarget = [NSString stringWithUTF8String:salestarget];
            
            char* profittarget = (char*)sqlite3_column_text(stmt, 5);
            if (profittarget)
                data.profittarget = [NSString stringWithUTF8String:profittarget];
            
            char* teambiulding = (char*)sqlite3_column_text(stmt, 6);
            if (teambiulding)
                data.teambiulding = [NSString stringWithUTF8String:teambiulding];
            
            char* productdev = (char*)sqlite3_column_text(stmt, 7);
            if (productdev)
                data.productdev = [NSString stringWithUTF8String:productdev];
  
            data.projectno = (int)sqlite3_column_int(stmt, 8);
            data.companyno = (int)sqlite3_column_int(stmt, 9);

            [listData   addObject:data];
            
        }
        NSLog(@"%d",[listData count]);
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return listData;

}
+(int)SaveId:(int)no 
      stdate:(NSString *)stdate  
     enddate:(NSString *)enddate 
 totalbudget:(NSString *)totalbudget 
 salestarget:(NSString *)salestarget 
profittarget:(NSString *)profittarget
teambiulding:(NSString *)teambiulding 
  productdev:(NSString *)productdev
    prjectno:(int)projectno
    companyno:(int)companyno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectplan(no,stdate,enddate,totalbudget,salestarget,profittarget,teambiulding,productdev,projectno,companyno) Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_text(stmt, 2, [stdate UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [enddate UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [totalbudget UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [salestarget UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 6, [profittarget UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 7, [teambiulding UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 8, [productdev UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, projectno);
    sqlite3_bind_int(stmt, 10, companyno);
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
    no = [PBPlanData SaveId:self.no stdate:self.stdate  enddate:self.enddate totalbudget:self.totalbudget salestarget:self.salestarget profittarget:self.profittarget teambiulding:self.teambiulding productdev:self.productdev prjectno:self.projectno companyno:self.companyno];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from projectplan where no = ?  ";
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
