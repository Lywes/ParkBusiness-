//
//  FAGroupData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAGroupData.h"
static sqlite3* database = nil;
@implementation FAGroupData
@synthesize no,groupid,groupname,createtime,imgpath,flag;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)search:(int)groupid
                    name:(NSString*)name
                   limit:(int)limitNumber
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 0 order by id desc "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where groupid is ?  "]UTF8String];
    const char *titleSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 0 and groupname like ? order by id desc "]UTF8String];
    const char *limitSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 0 order by id desc limit ?,25"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (groupid>0) {
        sql = noSearchSql;
    }
    if(name){
        sql = titleSearchSql;
    }
    if (limitNumber >= 0) {
        sql = limitSearchSql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(groupid>0){
            sqlite3_bind_int(stmt, 1, groupid);
        }
        if(limitNumber>=0){
            sqlite3_bind_int(stmt, 1, limitNumber);
        }
        if(name){
            NSString* likeName = [NSString stringWithFormat:@"%@%%",name];
            sqlite3_bind_text(stmt, 1, [likeName UTF8String], -1, SQLITE_TRANSIENT);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAGroupData* data = [[FAGroupData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            data.groupid = (int)sqlite3_column_int(stmt, 1);
            
            char* cName = (char*)sqlite3_column_text(stmt, 2);
            if (cName)
                data.groupname = [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.imgpath = [NSString stringWithUTF8String:cName];
            data.flag = (int)sqlite3_column_int(stmt, 4);
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 5)];
            
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
+(FAGroupData *)getGroupDataById:(int)groupid{
    NSMutableArray *groups = [FAGroupData search:groupid name:nil limit:-1];
    if ([groups count]>0) {
        return [groups objectAtIndex:0];
    }
    return [[FAGroupData alloc] init];
}
+(int)getGroupFlagById:(int)groupid{
    FAGroupData* data = [FAGroupData getGroupDataById:groupid];
    return data.flag;
}
+(NSMutableArray*)searchInstitude:(int)groupid
                    name:(NSString*)name
                   limit:(int)limitNumber
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 1 order by id desc "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where groupid is ?  "]UTF8String];
    const char *titleSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 1 and groupname like ? order by id desc "]UTF8String];
    const char *limitSearchSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 1 order by id desc limit ?,25"]UTF8String];
    const char *institudeSql = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = 1 and groupid <> ? order by id desc"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    const char *sql = allSql;
    if ([PBUserModel getPasswordAndKind].kind != 2) {
        sql = institudeSql;
    }
    if (groupid>0) {
        sql = noSearchSql;
    }
    if(name){
        sql = titleSearchSql;
    }
    if (limitNumber >= 0) {
        sql = limitSearchSql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if ([PBUserModel getPasswordAndKind].kind != 2) {
            sqlite3_bind_int(stmt, 1, [PBUserModel getCompanyno]);
        }
        if(groupid>0){
            sqlite3_bind_int(stmt, 1, groupid);
        }
        if(limitNumber>=0){
            sqlite3_bind_int(stmt, 1, limitNumber);
        }
        if(name){
            NSString* likeName = [NSString stringWithFormat:@"%@%%",name];
            sqlite3_bind_text(stmt, 1, [likeName UTF8String], -1, SQLITE_TRANSIENT);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAGroupData* data = [[FAGroupData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            data.groupid = (int)sqlite3_column_int(stmt, 1);
            
            char* cName = (char*)sqlite3_column_text(stmt, 2);
            if (cName)
                data.groupname = [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.imgpath = [NSString stringWithUTF8String:cName];
            data.flag = (int)sqlite3_column_int(stmt, 4);
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 5)];
            
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
+(NSMutableArray*)searchGroupDataWithFlag:(int)flag withoutGid:(int)gid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql  = [[NSString stringWithFormat:@"%@",@"select * from groupmaster where flag = ? order by id desc "]UTF8String];
    const char *noSql = [[NSString stringWithFormat:@"%@",@"select a.*,b.no from groupmaster a left join companyinfo as b on b.name = a.groupname where a.flag = ? and b.no is null order by id desc"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    const char *sql = allSql;
    if (gid>0) {
        sql = noSql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if ([PBUserModel getPasswordAndKind].kind != 2) {
            sqlite3_bind_int(stmt, 1, [PBUserModel getCompanyno]);
        }
        sqlite3_bind_int(stmt, 1, flag);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAGroupData* data = [[FAGroupData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            data.groupid = (int)sqlite3_column_int(stmt, 1);
            
            char* cName = (char*)sqlite3_column_text(stmt, 2);
            if (cName)
                data.groupname = [NSString stringWithUTF8String:cName];
            cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.imgpath = [NSString stringWithUTF8String:cName];
            data.flag = (int)sqlite3_column_int(stmt, 4);
            data.createtime = [NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, 5)];
            
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
+(FAGroupData *)getInstitudeDataById:(int)groupid{
    NSMutableArray *groups = [FAGroupData searchInstitude:groupid name:nil limit:-1];
    if ([groups count]>0) {
        return [groups objectAtIndex:0];
    }
    return [[FAGroupData alloc] init];
}
+(BOOL)isOldGroup:(int)groupid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select count(groupid) from groupmaster where groupid =? "]UTF8String];
    int count=0;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, groupid);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            count = (int)sqlite3_column_int(stmt, 0);
            
            
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    if (count >0) {
        return YES;
    }
    return NO;

}
+(int)saveId:(int)no
     groupid:(int)groupid
     flag:(int)flag
   groupname:(NSString*)groupname
   imgpath:(NSString*)imgpath
  createtime:(NSDate*)createtime
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into groupmaster(id,groupid,groupname,imgpath,flag,createtime",@") Values(?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, groupid);
    sqlite3_bind_text(stmt, 3, [groupname UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [imgpath UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, flag);
    sqlite3_bind_int(stmt, 6, [createtime timeIntervalSince1970]);
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
    if ((self.no==-1 && ![FAGroupData isOldGroup:self.groupid]) || (self.no>0)) {
        self.no = [FAGroupData saveId:self.no groupid:self.groupid flag:self.flag groupname:self.groupname imgpath:self.imgpath createtime:self.createtime];
    }
    
}
+(void)deleteInstitudeData{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from groupmaster where flag > 0 ";
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
    if (SQLITE_DONE != sqlite3_step(stmt)) {
        NSAssert1(0, @"Error while inserting data . '%s'", sqlite3_errmsg(database));
        sqlite3_reset(stmt);
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from groupmaster where id = ? ";
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

-(void)deleteRecord
{
    [FAGroupData deleteId:self.no];
}
@end
