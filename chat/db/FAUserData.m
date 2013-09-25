//
//  FAUserData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAUserData.h"
static sqlite3* database = nil;
@implementation FAUserData
@synthesize no,name,pushid,signature,icon,parkno;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(FAUserData*)search
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select id,identifier,name,signature,imagepath from user "]UTF8String];
    
    // [listData retain];
    FAUserData* data = [[[FAUserData alloc]init] autorelease];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* cPushid = (char*)sqlite3_column_text(stmt, 1);
            if (cPushid)
                data.pushid = [NSString stringWithUTF8String:cPushid];
            
            char* cName = (char*)sqlite3_column_text(stmt, 2);
            if (cName)
                data.name = [NSString stringWithUTF8String:cName];
            
            cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.signature = [NSString stringWithUTF8String:cName];
            
            
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 4) length:(int)sqlite3_column_bytes(stmt, 4)];
            if (imageData) {
                data.icon = [UIImage imageWithData:imageData];
            }
            
            
            //            cName = (char*)sqlite3_column_text(stmt, 5);
            //            if (cName)
            //                data.deviceid = [NSString stringWithUTF8String:cName];
            
            
            
            break;
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
      pushid:(NSString*)pushid
        name:(NSString*)name
   signature:(NSString*)signature
        icon:(UIImage*)icon
      parkno:(int)parkno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into user(id,identifier,name,signature,",@"imagepath,parkno,messageflg,showflg,activeflg) Values(?,?,?,?,?,?,1,1,1)"]UTF8String];
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
    sqlite3_bind_text(stmt, 2, [pushid UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [signature UTF8String], -1, SQLITE_TRANSIENT);
    NSData *imageData;
    if (icon) {
        imageData = UIImagePNGRepresentation(icon);
        sqlite3_bind_blob(stmt, 5, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 6, parkno);
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
    no = [FAUserData saveId:self.no pushid:self.pushid name:self.name signature:self.signature icon:self.icon parkno:self.parkno];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from user  ";
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
    //sqlite3_bind_int(stmt, 1, recordId);
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    
}

-(void)deleteRecord
{
    [FAUserData deleteId:no];
}
@end
