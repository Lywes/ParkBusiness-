//
//  PBteamData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBteamData.h"
static sqlite3* database = nil;
@implementation PBteamData
@synthesize no,name,teamjob,introduce,years,married,experience,projectno,companyno,imagepath;
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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,name,teamjob,introduce,years,married,experience,projectno,companyno,imagepath from projectgroup  where projectno = ?"]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    // [listData retain];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }

    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, projectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBteamData* data = [[[PBteamData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* name = (char*)sqlite3_column_text(stmt, 1);
            if (name)
                data.name = [NSString stringWithUTF8String:name];
           data.teamjob = (int)sqlite3_column_int(stmt, 2);
            char* introduce = (char*)sqlite3_column_text(stmt, 3);
            if (introduce)
                data.introduce = [NSString stringWithUTF8String:introduce];
            
            char* years = (char*)sqlite3_column_text(stmt, 4);
            if (years)
                data.years = [NSString stringWithUTF8String:years];
            
            char* married = (char*)sqlite3_column_text(stmt, 5);
            if (married)
                data.married = [NSString stringWithUTF8String:married];
            
            char* experience = (char*)sqlite3_column_text(stmt, 6);
            if (experience)
                data.experience = [NSString stringWithUTF8String:experience];
            data.projectno = (int)sqlite3_column_int(stmt, 7);
            data.companyno = (int)sqlite3_column_int(stmt, 8);
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 9) length:(int)sqlite3_column_bytes(stmt, 9)];
            if (imageData) {
                data.imagepath = [UIImage imageWithData:imageData];
            }
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
        name:(NSString *)name 
     teamjob:(int)teamjob
  introduce:(NSString *)introduce 
       years:(NSString *)years
     married:(NSString *)married 
  experience:(NSString *)experience
    projectno:(int)projectno
    companyno:(int)companyno
imagepath:(UIImage *)imagepath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectgroup(no,name,teamjob,introduce,years,married,experience,projectno,companyno,imagepath) Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    if (no == -1||no==0) {
        
    }else{
        sqlite3_bind_int(stmt, 1, no);
    }
    sqlite3_bind_text(stmt, 2, [name UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, teamjob);
    sqlite3_bind_text(stmt, 4, [introduce UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [years UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 6, [married UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 7, [experience UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 8, projectno);
    sqlite3_bind_int(stmt, 9, companyno);
    NSData *imageData;
    if (imagepath) {
        imageData = UIImagePNGRepresentation(imagepath);
        sqlite3_bind_blob(stmt, 10, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
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
    no = [PBteamData SaveId:self.no name:self.name teamjob:self.teamjob introduce:self.introduce years:self.years married:self.married experience:self.experience projectno:self.projectno companyno:self.companyno imagepath:self.imagepath];
}

+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from projectgroup where no = ?  ";
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
