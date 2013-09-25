    //
    //  PBAddAnLiData.m
    //  ParkBusiness
    //
    //  Created by  on 13-4-17.
    //  Copyright (c) 2013年 wangzhigang. All rights reserved.
    //

#import "PBAddAnLiData.h"

static sqlite3 *database = nil;

@implementation PBAddAnLiData

@synthesize no;
@synthesize name;
@synthesize trade;
@synthesize projectintroduce;
@synthesize projectstage;
@synthesize starttime;
@synthesize money;
@synthesize moneyunit;
@synthesize ycno;
@synthesize projectinfono;

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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,name,trade,projectintroduce,projectstage,starttime,money,moneyunit,ycno,projectinfono from project"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBAddAnLiData* data = [[[PBAddAnLiData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* name = (char*)sqlite3_column_text(stmt, 1);
            if (name)
                data.name = [NSString stringWithUTF8String:name];
            char* trade = (char*)sqlite3_column_text(stmt, 2);
            if (trade)
                data.trade = [NSString stringWithUTF8String:trade];
            
            char* projectintroduce = (char*)sqlite3_column_text(stmt, 3);
            if (projectintroduce)
                data.projectintroduce = [NSString stringWithUTF8String:projectintroduce];
            
            char* projectstage = (char*)sqlite3_column_text(stmt, 4);
            if (projectstage)
                data.projectstage = [NSString stringWithUTF8String:projectstage];
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            data.starttime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 5)]];
            
            data.money = (int)sqlite3_column_int(stmt, 6);
            
            data.moneyunit = (int)sqlite3_column_int(stmt, 7);
            
            data.ycno = (int)sqlite3_column_int(stmt, 8);
            
            data.projectinfono = (int)sqlite3_column_int(stmt, 9);
            
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

+(int)SaveId:(int)no 
        name:(NSString *)name 
       trade:(NSString *)trade 
projectintroduce:(NSString *)projectintroduce
projectstage:(NSString *)projectstage
       starttime:(NSString *)starttime 
       money:(int)money
   moneyunit:(int)moneyunit
        ycno:(int)ycno
projectinfono:(int)projectinfono
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"insert or replace into project(name,trade,projectintroduce,projectstage,starttime,money,moneyunit,ycno,projectinfono,no,cdate) Values(?,?,?,?,?,?,?,?,?,?,?)" UTF8String];
    
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
        
    } else{
        sqlite3_bind_int(stmt, 10, no);
    }
    sqlite3_bind_text(stmt, 1, [name UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [trade UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [projectintroduce UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [projectstage UTF8String], -1, SQLITE_TRANSIENT);
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *sTime = [formatter dateFromString:starttime];
    sqlite3_bind_int(stmt, 5, [sTime timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 6, money);
    sqlite3_bind_int(stmt, 7, moneyunit);
    sqlite3_bind_int(stmt, 8, ycno);
    sqlite3_bind_int(stmt, 9, projectinfono);
    sqlite3_bind_int(stmt, 11, [[NSDate date] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        //else
        //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
    
}
+(int)replaceKeyValue:(int)oldNo withNo:(int)newNo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [@"update project set no = ? where no = ?" UTF8String];
    
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
    sqlite3_bind_int(stmt, 1, newNo);
    sqlite3_bind_int(stmt, 2, oldNo);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return newNo;
    
}
@end
