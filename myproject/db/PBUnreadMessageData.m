//
//  PBUnreadMessageData.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBUnreadMessageData.h"
static sqlite3* database = nil;
@implementation PBUnreadMessageData
@synthesize oldnum,newnum,kind,needsno;
-(id)init
{
    self = [super init];
    if(self){

    }
    return self;
}
//通过类型检索未读信息
+(NSMutableArray*)searchMessageWithKind:(NSString*)kinds
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allsql = [[NSString stringWithFormat:@"%@",@"select kind,oldnum,newnum from unreadmessage"]UTF8String];
    const char *kindsql = [[NSString stringWithFormat:@"%@",@"select kind,oldnum,newnum from unreadmessage where kind = ? "]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    const char *sql = allsql;
    if (kinds) {
        sql = kindsql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if (kinds) {
            sqlite3_bind_text(stmt, 1, [kinds UTF8String],-1, SQLITE_TRANSIENT);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBUnreadMessageData* data = [[[PBUnreadMessageData alloc]init] autorelease];
            char* kind = (char*)sqlite3_column_text(stmt, 0);
            if (kind)
                data.kind = [NSString stringWithUTF8String:kind];
            data.oldnum = (int)sqlite3_column_int(stmt, 1);
            data.newnum = (int)sqlite3_column_int(stmt, 2);
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
//检索信息数目
+(int)countOfUnreadMessageWithKind:(NSString*)kinds{
    int unreadcount = 0;
    NSMutableArray* arr = [PBUnreadMessageData searchMessageWithKind:kinds];
    PBUnreadMessageData* data = [arr objectAtIndex:0];
    unreadcount = data.newnum-data.oldnum;
    return unreadcount;
}
//更新未读信息数
+(int)updateOldNumWithKind:(NSString*)kind{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update unreadmessage set oldnum = newnum where kind = ?"]UTF8String];
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
    sqlite3_bind_text(stmt, 1, [kind UTF8String],-1, SQLITE_TRANSIENT);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return 1;
}
//更新最新记录数
+(int)updateNewNumWithKind:(NSString*)kind withNewNum:(int)newnum{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update unreadmessage set newnum = ? where kind = ?"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, newnum);
    sqlite3_bind_text(stmt, 2, [kind UTF8String],-1, SQLITE_TRANSIENT);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return 1;
}
//与服务器信息同步
+(int)updateMessageData:(NSMutableDictionary*)messageDic
{
    int i = 0;
    for (id key in messageDic) {
        NSString* kind = (NSString*)key;
        int num = [[messageDic objectForKey:kind] intValue];
        [self updateNewNumWithKind:kind withNewNum:num];
        i++;
    }
    return i;
}
//保存我的需求信息
+(int)saveMyNeedsWithDic:(NSMutableDictionary*)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into unreadneedsmessage(no,needsno,type,oldnum,newnum) Values(?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"needsno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"type"] intValue]);
    sqlite3_bind_int(stmt, 4, 0);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"count"] intValue]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return 1;
}
//从服务器获取更新需求信息
+(int)updateNeedsMessageData:(NSMutableArray*)messageArr
{
    int i = 0;
    NSMutableArray* zixunArr = [messageArr objectAtIndex:0];
    int newnum = [[zixunArr objectAtIndex:0] intValue];
    [self updateNewNumWithKind:@"zixun" withNewNum:newnum];
    NSMutableArray* needsArr = [messageArr objectAtIndex:1];
    if ([needsArr count]>0) {//有需求
        for (NSMutableDictionary* dic in needsArr) {
            int needsno = [[dic objectForKey:@"needsno"] intValue];
            int type = [[dic objectForKey:@"type"] intValue];
            NSMutableArray* dataArr = [self searchMyNeedsMessageWithType:type withNeedsNo:needsno];
            if ([dataArr count]==0) {
                [self saveMyNeedsWithDic:dic];
            }else{
                [self updateMyNeedsWithDic:dic];
            }
        }
    }
    return i;
}
//更新需求未读信息数
+(int)updateMyNeedsWithDic:(NSMutableDictionary*)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update unreadneedsmessage set newnum = ? where needsno = ? and type = ? "]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"count"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"needsno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"type"] intValue]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return 1;
}
//通过类型检索需求反馈信息
+(NSMutableArray*)searchMyNeedsMessageWithType:(int)type withNeedsNo:(int)needsno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allsql = [[NSString stringWithFormat:@"%@",@"select needsno,oldnum,newnum from unreadneedsmessage"]UTF8String];
    const char *typesql = [[NSString stringWithFormat:@"%@",@"select needsno,oldnum,newnum from unreadneedsmessage where type = ? "]UTF8String];
    const char *needsnosql = [[NSString stringWithFormat:@"%@",@"select needsno,oldnum,newnum from unreadneedsmessage where needsno = ? and type = ?"]UTF8String];
    NSMutableArray* listData = [[[NSMutableArray alloc]init]autorelease];
    const char *sql = allsql;
    if (type>=0) {
        sql = typesql;
    }
    if (needsno>0) {
        sql = needsnosql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if (type>=0) {
            sqlite3_bind_int(stmt, 1, type);
        }
        if (needsno>0) {
            sqlite3_bind_int(stmt, 1, needsno);
            sqlite3_bind_int(stmt, 2, type);
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBUnreadMessageData* data = [[[PBUnreadMessageData alloc]init] autorelease];
            data.needsno = (int)sqlite3_column_int(stmt, 0);
            data.oldnum = (int)sqlite3_column_int(stmt, 1);
            data.newnum = (int)sqlite3_column_int(stmt, 2);
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
//检索需求未读信息数目
+(int)countOfUnreadNeedsMessageWithType:(int)type WithNeedsNo:(int)needsno{
    int unreadcount = 0;
    NSMutableArray* arr = [self searchMyNeedsMessageWithType:type withNeedsNo:needsno];
    for (PBUnreadMessageData* data in arr) {
        int count = data.newnum-data.oldnum;
        unreadcount +=count;
    }
    return unreadcount;
}

//更新需求未读信息数
+(int)updateOldNumWithNeedsNo:(int)needsno withType:(int)type{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update unreadneedsmessage set oldnum = newnum where needsno = ? and type = ?"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, needsno);
    sqlite3_bind_int(stmt, 2, type);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return 1;
}
//更新需求信息
+(void)updateMyNeedsWithArray:(NSMutableArray*)array withType:(int)type{
    for (NSMutableDictionary* dic in array) {
        int needsno = [[dic objectForKey:@"no"] intValue];
        NSMutableArray* dataArr = [self searchMyNeedsMessageWithType:type withNeedsNo:needsno];
        if ([dataArr count]==0) {
            NSMutableDictionary* dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"no"],@"needsno",[NSString stringWithFormat:@"%d",type],@"type", nil];
            [self saveMyNeedsWithDic:dataDic];
        }
    }
}
@end
