//
//  PBIndustryDB.m
//  ParkBusiness
//
//  Created by  on 13-4-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBIndustryDB.h"
static sqlite3* database = nil;
@implementation PBIndustryDB

@synthesize no;
@synthesize kind;
@synthesize name;

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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select kind,id,name from kbn_master  where kind = 'industry'"]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
        // [listData retain];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBIndustryDB* data = [[[PBIndustryDB alloc]init] autorelease];  
            char* kind = (char*)sqlite3_column_text(stmt, 0);
            if (kind)
                data.kind = [NSString stringWithUTF8String:kind];
            data.no = (int)sqlite3_column_int(stmt, 1);
            char* name = (char*)sqlite3_column_text(stmt, 2);
            if (name)
                data.name = [NSString stringWithUTF8String:name];
            
            [listData   addObject:data];
        }
        
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return listData;
    
}

+(NSString*)searchKbnIdByName:(NSString*)name
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select id from kbn_master  where kind = 'industry' and name = ?"]UTF8String];
    int kbnId = -1;
        // [listData retain];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 0, [name UTF8String],-1, SQLITE_TRANSIENT);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            kbnId = (int)sqlite3_column_int(stmt, 1);
        }
        
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return [NSString stringWithFormat:@"%d",kbnId];
    
}
@end
