//
//  FAFriendData.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAFriendData.h"
static sqlite3* database = nil;
@implementation FAFriendData
@synthesize no,signature,friendid,friendname,imgpath,icon,friendgroupid,remark;

-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(BOOL)isFriend:(int)friendid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select count(friendid) from friend where friendid =? "]UTF8String];
    int count=0;
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }
    
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, friendid);
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
+(NSMutableArray*)search:(int)friendid
             friendgroupid:(int)friendgroupid
                    name:(NSString*)name
                   limit:(int)limitNumber
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *allSql = [[NSString stringWithFormat:@"%@",@"select * from friend order by id desc "]UTF8String];
    const char *noSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friend where friendid is ?  "]UTF8String];
    const char *groupSql = [[NSString stringWithFormat:@"%@",@"select * from friend a left join friendgroupmember as b on a.friendid = b.fid where b.fgid = ? order by a.id desc "]UTF8String];
    const char *titleSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friend a left join friendgroupmember as b on a.friendid = b.fid where b.fgid = ? and friendname like ? order by id desc "]UTF8String];
    const char *nameSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friend where friendname like ? order by id desc "]UTF8String];
    const char *limitSearchSql = [[NSString stringWithFormat:@"%@",@"select * from friend order by id desc limit ?,25"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    // [listData retain];
    const char *sql = allSql;
    if (friendid > 0) {
        sql = noSearchSql;
    }
    if (friendgroupid >0) {
        sql = groupSql;
    }
    if(name){
        if (friendgroupid >0) {
            sql = titleSearchSql;
        }else{
            sql = nameSearchSql;
        }
        
    }
    if (limitNumber >= 0) {
        sql = limitSearchSql;
    }
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        if(friendid!=-1){
            sqlite3_bind_int(stmt, 1, friendid);
        }
        if (friendgroupid != -1) {
            sqlite3_bind_int(stmt, 1, friendgroupid);
        }
        if(limitNumber!=-1){
            sqlite3_bind_int(stmt, 1, limitNumber);
        }
        if(name){
            if (friendgroupid >0) {
                sqlite3_bind_int(stmt, 1, friendgroupid);
                NSString* likeName = [NSString stringWithFormat:@"%@%%",name];
                sqlite3_bind_text(stmt, 2, [likeName UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                NSString* likeName = [NSString stringWithFormat:@"%@%%",name];
                sqlite3_bind_text(stmt, 1, [likeName UTF8String], -1, SQLITE_TRANSIENT);
            }
            
        }
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            FAFriendData* data = [[FAFriendData alloc]init];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* cName = (char*)sqlite3_column_text(stmt, 1);
            if (cName)
                data.signature = [NSString stringWithUTF8String:cName];
            
            data.friendid = (int)sqlite3_column_int(stmt, 2);
            
            cName = (char*)sqlite3_column_text(stmt, 3);
            if (cName)
                data.friendname = [NSString stringWithUTF8String:cName];
            
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 4) length:(int)sqlite3_column_bytes(stmt, 4)];
            if (imageData) {
                data.icon = [UIImage imageWithData:imageData];
            }

            cName = (char*)sqlite3_column_text(stmt, 5);
            if (cName)
                data.imgpath = [NSString stringWithUTF8String:cName];
            
            data.friendgroupid = (int)sqlite3_column_int(stmt, 6);
            
            cName = (char*)sqlite3_column_text(stmt, 7);
            if (cName)
                data.remark = [NSString stringWithUTF8String:cName];
            
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

+(void)updateRemark:(NSString*)remark withId:(int)friendid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"update friend set remark=? where friendid=?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    sqlite3_bind_text(stmt, 1, [remark UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 2, friendid);
    
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+(int)saveId:(int)no
   signature:(NSString*)signature
    friendid:(int)friendid
  friendname:(NSString*)friendname
     imgpath:(NSString*)imgpath
        icon:(UIImage*)icon
friendgroupid:(int)friendgroupid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into friend(id,signature,friendid,friendname,icon,",@"imgpath,friendgroupid) Values(?,?,?,?,?,?,?)"]UTF8String];
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
    if ([signature isKindOfClass:[NSNull class]]) {
        signature = @"";
    }
    sqlite3_bind_text(stmt, 2, [signature UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, friendid);
    
    sqlite3_bind_text(stmt, 4, [friendname UTF8String],-1, SQLITE_TRANSIENT);
    NSData *imageData;
    if (icon) {
        imageData = UIImagePNGRepresentation(icon);
        sqlite3_bind_blob(stmt, 5, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    if ([imgpath isKindOfClass:[NSNull class]]) {
        imgpath = @"";
    }
    sqlite3_bind_text(stmt, 6, [imgpath UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 7, friendgroupid);
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
    if ((self.no==-1 && ![FAFriendData isFriend:self.friendid]) || (self.no>0)) {
        self.no = [FAFriendData saveId:self.no signature:self.signature  friendid:self.friendid friendname:self.friendname imgpath:self.imgpath icon:self.icon friendgroupid:self.friendgroupid];
    }
    
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from friend where friendid = ? ";
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
    [FAFriendData deleteId:self.friendid];
}
+(FAFriendData *)getFriendDataById:(int)friendid{
    NSMutableArray *friends = [FAFriendData search:friendid friendgroupid:-1 name:nil limit:-1];
    FAFriendData *friend = [[FAFriendData alloc] init];
    if ([friends count]>0) {
        friend = (FAFriendData *)[friends objectAtIndex:0];
        
    }
    return friend;
}
@end
