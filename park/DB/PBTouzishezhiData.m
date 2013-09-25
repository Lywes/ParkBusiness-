//
//  PBTouzishezhiData.m
//  ParkBusiness
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBTouzishezhiData.h"

static sqlite3 *database = nil;

@implementation PBTouzishezhiData

@synthesize no;
@synthesize investtrade;
@synthesize investsubdivision;
@synthesize annualinvestno;
@synthesize projectfund_avg;
@synthesize carveoutresourse;

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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select id,investtrade,investsubdivision,annualinvestno,projectfund_avg,carveoutresourse from user"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
        // [listData retain];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBTouzishezhiData* data = [[[PBTouzishezhiData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
        
            char* investtrade = (char*)sqlite3_column_text(stmt, 1);
            if (investtrade)
                data.investtrade = [NSString stringWithUTF8String:investtrade];
            char* investsubdivision = (char*)sqlite3_column_text(stmt, 2);
            if (investsubdivision)
                data.investsubdivision = [NSString stringWithUTF8String:investsubdivision];
            
            char* annualinvestno = (char*)sqlite3_column_text(stmt, 3);
            if (annualinvestno)
                data.annualinvestno = [NSString stringWithUTF8String:annualinvestno];
            
            data.projectfund_avg = (int)sqlite3_column_int(stmt, 4);
            
            char* carveoutresourse = (char*)sqlite3_column_text(stmt, 5);
            if (carveoutresourse)
                data.carveoutresourse = [NSString stringWithUTF8String:carveoutresourse];
             [listData   addObject:data];
            
            
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    NSLog(@"%@",listData);
    return listData;

}

+(int)SaveId:(int)no 
 investtrade:(NSString *)investtrade 
   investsubdivision:(NSString *)investsubdivision 
  annualinvestno:(NSString *)annualinvestno 
  projectfund_avg:(int)projectfund_avg
  carveoutresourse:(NSString *)carveoutresourse
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set investtrade=?,investsubdivision=?,annualinvestno=?,projectfund_avg=?,carveoutresourse=?"]UTF8String];
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
        
    } 
    sqlite3_bind_text(stmt, 1, [investtrade UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [investsubdivision UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [annualinvestno UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, projectfund_avg);
    sqlite3_bind_text(stmt, 5, [carveoutresourse UTF8String], -1, SQLITE_TRANSIENT);
   
    
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        //else
        //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;

}

@end
