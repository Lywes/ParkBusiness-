//
//  PBProjectInfoListModel.m
//  ParkBusiness
//
//  Created by QDS on 13-4-17.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectInfoListModel.h"

static sqlite3* database = nil;

@implementation PBProjectInfoListModel

-(id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

//从本地数据库中获取项目编号
+ (NSMutableArray *) getProjectNameFromSQL
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select proname from projectinfo"]UTF8String];
    NSString *projectname = [NSString string];
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return dataArray;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *projectName_char = (char *)sqlite3_column_text(stmt, 0);
            if (projectName_char) {
                projectname = [NSString stringWithUTF8String:projectName_char];
                [dataArray addObject:projectname];
            }
        }
    }else{
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return dataArray;
}

+ (NSMutableArray *) getMyFriendListFromSQL
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select friendid from friend"]UTF8String];
    int friendIdNO = -1;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return dataArray;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //            char *projectName_char = (char *)sqlite3_column_text(stmt, 0);
            friendIdNO = sqlite3_column_int(stmt, 0);
            if (friendIdNO) {
                [dataArray addObject:[NSString stringWithFormat:@"%d", friendIdNO]];
            }
        }
    }else{
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return dataArray;
}

@end
