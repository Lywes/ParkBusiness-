//
//  PBUserData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#import "PBUserModel.h"

static sqlite3* database = nil;
@implementation PBUserModel
@synthesize  userId;
@synthesize  kind;
@synthesize  tel;
@synthesize  password;
-(id)init
{
    self = [super init];
    if(self){
        kind = -1;
    }
    return self;
}

+(int)getUserId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select id from user"]UTF8String];
    int userId = -1;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return userId;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            userId = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return userId;
}

+(int)getCompanyno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select companyno from user"]UTF8String];
    int companyno = -1;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return companyno;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            companyno = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return companyno;
}

+(int)getParkNo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select parkno from user"]UTF8String];
    int parkno = -1;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return parkno;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            parkno = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return parkno;
}
+(PBUserModel*)getPasswordAndKind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select password,kind from user"]UTF8String];
    const char *sql = allSql;
    PBUserModel* data = [[PBUserModel alloc]init];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return data;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char* cpassword = (char*)sqlite3_column_text(stmt,0);
            if (cpassword)
                data.password = [NSString stringWithUTF8String:cpassword];
            data.kind = (int)sqlite3_column_int(stmt, 1);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return data;
}
+(NSString*)getTel
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select tel from user"]UTF8String];
    NSString* parkno = @"";
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return parkno;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char* cparkno = (char*)sqlite3_column_text(stmt,0);
            if (cparkno)
                parkno = [NSString stringWithUTF8String:cparkno];
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return parkno;
}
+(int)getVersion{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select version from user"]UTF8String];
    int parkno = -1;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return parkno;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            parkno = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return parkno;
}
+(int)saveId:(int)userId
         tel:(NSString*)tel
    password:(NSString*)password
        kind:(int)kind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    // NSLog(dbPath);
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update user set tel = ?,password = ?,kind = ? where id = ?"]UTF8String];
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

    sqlite3_bind_text(stmt, 1, [tel UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [password UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, kind);
    sqlite3_bind_int(stmt, 4, userId);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        userId = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return userId;
}
+(int)updateKind:(int)kind
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    // NSLog(dbPath);
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update user set kind = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return no;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return no;
    }
    
    sqlite3_bind_int(stmt, 1, kind);
    
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
+(int)updateCompanyno:(int)companyno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    // NSLog(dbPath);
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update user set companyno = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return no;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return no;
    }
    
    sqlite3_bind_int(stmt, 1, companyno);
       
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

+(BOOL)isRegister
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select password,kind,name,companyno from user"]UTF8String];
    const char *sql = allSql;
    BOOL regist = NO;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return regist;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char* cpassword = (char*)sqlite3_column_text(stmt,0);
            NSString* password = @"";
            NSString* name =  @"";
            if (cpassword)
                password = [NSString stringWithUTF8String:cpassword];
            
            int kind = (int)sqlite3_column_int(stmt, 1);
            char* cname = (char*)sqlite3_column_text(stmt,2);
            if (cname)
                name = [NSString stringWithUTF8String:cname];
            int companyno = (int)sqlite3_column_int(stmt, 3);
            if (![password isEqualToString:@""]&&![name isEqualToString:@""]&&kind>=0) {
                if (kind>0&&companyno<=0) {
                    regist=NO;
                }else{
                    regist = YES;
                }
            }
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return regist;
}

//更新诚信积分
+(int)updateCredit:(int)credit
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    // NSLog(dbPath);
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update user set credit = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return no;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return no;
    }
    
    sqlite3_bind_int(stmt, 1, credit);
    
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
//获取诚信积分
+(int)getCredit
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select credit from user"]UTF8String];
    int credit = 0;
    const char *sql = allSql;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return credit;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            credit = (int)sqlite3_column_int(stmt, 0);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return credit;
}
//执行SQL语句
+(BOOL)executeWithSql:(NSString*)executeSql
{
    if (executeSql.length==0) {
        return YES;
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [executeSql UTF8String];
    const char *sql = allSql;
    BOOL succ = NO;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return succ;
    }
    if (SQLITE_DONE != sqlite3_step(stmt)){
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        return succ;
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return !succ;
}
-(void)saveRecord
{
    userId = [PBUserModel saveId:userId tel:tel password:password kind:kind];
}

-(void)deleteRecord
{
    //    [DataMode1 deleteId:recordId];
}
+(NSString *)decodeFromPercentEscapeString:(NSString *)string {
    return (NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(CFStringRef) string,CFSTR(""),kCFStringEncodingUTF8);
}
+(NSDate*)convertDateFromString:(NSString*)string{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate* date = [formatter dateFromString:string];
    [formatter release];
    return date;
    
}
@end