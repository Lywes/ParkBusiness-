    //
    //  PBMySheZhiData.m
    //  ParkBusiness
    //
    //  Created by  on 13-4-17.
    //  Copyright (c) 2013年 wangzhigang. All rights reserved.
    //

#import "PBMySheZhiData.h"

static sqlite3* database = nil;

@implementation PBMySheZhiData
@synthesize no,imagepath,name,sex,signature,companyname,companyjob,emailaddress,qq,city,sinablog,linkedin,skype,msn;


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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select id,imagepath,name,sex,signature,companyname,companyjob,emailaddress,qq,city,sinablog,linkedin,skype,msn from user "]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
        // [listData retain];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBMySheZhiData* data = [[[PBMySheZhiData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 1) length:(int)sqlite3_column_bytes(stmt, 1)];
            if (imageData) {
                data.imagepath = [UIImage imageWithData:imageData];
            }
            char* name = (char*)sqlite3_column_text(stmt, 2);
            if (name)
                data.name = [NSString stringWithUTF8String:name];
            char* sex = (char*)sqlite3_column_text(stmt, 3);
            if (sex)
                data.sex = [NSString stringWithUTF8String:sex];
            
            char* signature = (char*)sqlite3_column_text(stmt, 4);
            if (signature)
                data.signature = [NSString stringWithUTF8String:signature];
            
            char* companyname = (char*)sqlite3_column_text(stmt, 5);
            if (companyname)
                data.companyname = [NSString stringWithUTF8String:companyname];
            
            char* companyjob = (char*)sqlite3_column_text(stmt, 6);
            if (companyjob)
                data.companyjob = [NSString stringWithUTF8String:companyjob];
                //            char* trade = (char*)sqlite3_column_text(stmt, 7);
                //            if (trade)
                //                data.trade = [NSString stringWithUTF8String:trade];
                //Id,name,sex,signature,companyname,companyjob,trade,emailaddress,qq,city,sinablog,linkedin,skype,qqblog 
            char* emailaddress = (char*)sqlite3_column_text(stmt, 7);
            if (emailaddress)
                data.emailaddress = [NSString stringWithUTF8String:emailaddress];
            
            char* qq = (char*)sqlite3_column_text(stmt, 8);
            if (qq)
                data.qq = [NSString stringWithUTF8String:qq];
            
            char* city = (char*)sqlite3_column_text(stmt, 9);
            if (city)
                data.city = [NSString stringWithUTF8String:city];
            
            char* sinablog = (char*)sqlite3_column_text(stmt, 10);
            if (sinablog)
                data.sinablog = [NSString stringWithUTF8String:sinablog];
            
            char* linkedin = (char*)sqlite3_column_text(stmt, 11);
            if (linkedin)
                data.linkedin = [NSString stringWithUTF8String:linkedin];
            char* skype = (char*)sqlite3_column_text(stmt, 12);
            if (skype)
                data.skype = [NSString stringWithUTF8String:skype];
            char* msn = (char*)sqlite3_column_text(stmt, 13);
            if (msn)
                data.msn = [NSString stringWithUTF8String:msn];
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
         sex:(NSString *)sex 
   signature:(NSString *)signature 
 companyname:(NSString *)companyname
  companyjob:(NSString *)companyjob 
emailaddress:(NSString *)emailaddress
          qq:(NSString *)qq
        city:(NSString *)city
    sinablog:(NSString *)sinablog
    linkedin:(NSString *)linkedin
       skype:(NSString *)skype
         msn:(NSString *)msn
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set name=?,sex=?,signature=?,companyname=?,companyjob=?,emailaddress=?,qq=?,city=?,sinablog=?,linkedin=?,skype=?,msn=?"]UTF8String];
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
    sqlite3_bind_text(stmt, 1, [name UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, [sex UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [signature UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [companyname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [companyjob UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 6, [emailaddress UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 7, [qq UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 8, [city UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 9, [sinablog UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 10, [linkedin UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 11, [skype UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 12, [msn UTF8String], -1, SQLITE_TRANSIENT);
    
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        //else
        //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
    
}


+(void)saveRecord:(NSMutableDictionary *)dic
{
    [self SaveId:1 name:[dic objectForKey:@"姓名:"] sex:[dic objectForKey:@"性别:"] signature:[dic objectForKey:@"个性签名:"] companyname:[dic objectForKey:@"公司:"] companyjob:[dic objectForKey:@"职位:"] emailaddress:[dic objectForKey:@"邮箱:"] qq:[dic objectForKey:@"QQ:"] city:[dic objectForKey:@"所在城市:"] sinablog:[dic objectForKey:@"新浪微博:"] linkedin:[dic objectForKey:@"Linkedln:"] skype:[dic objectForKey:@"Facebook:"] msn:[dic objectForKey:@"twitter:"]];
}

+(void)SaveImage1:(UIImage *)image
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set imagepath = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
            //        return -1;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
            //        return -1;
    }
    
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 1, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        //else
        //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}

+(void)SaveImage:(UIImage *)image
{
    [self SaveImage1:image];
}

@end
