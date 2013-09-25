//
//  PBShezhiData.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBShezhiData.h"
#import "PBKbnMasterModel.h"
static sqlite3* database = nil;
@implementation PBShezhiData
@synthesize no,imagepath,name,sex,signature,companyname,companyjob,trade,emailaddress,qq,city,sinablog,linkedin,skype,msn,experience,soundflg,showflg,messageflg,companyno;

-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(NSMutableArray*)searchBy:(int)ID
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select id,a.imagepath,a.name,sex,signature,b.name,companyjob,trade,emailaddress,qq,city,sinablog,linkedin,skype,msn,soundflg,messageflg, showflg,b.no from user a left join companyinfo as b on b.no = a.companyno  where id = ?"]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
    // [listData retain];
    
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1,ID);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBShezhiData* data = [[[PBShezhiData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 1) length:(int)sqlite3_column_bytes(stmt, 1)];
            if (imageData) {
                data.imagepath = [UIImage imageWithData:imageData];
            }
            char* name = (char*)sqlite3_column_text(stmt, 2);
            if (name)
            {
                data.name = [NSString stringWithUTF8String:name];
            }
            data.sex = (int)sqlite3_column_int(stmt, 3);
            char* signature = (char*)sqlite3_column_text(stmt, 4);
            if (signature)
                data.signature = [NSString stringWithUTF8String:signature];
            
            char* companyname = (char*)sqlite3_column_text(stmt, 5);
            if (companyname)
                data.companyname = [NSString stringWithUTF8String:companyname];
            
            data.companyjob = (int)sqlite3_column_int(stmt, 6);
            data.trade = (int)sqlite3_column_int(stmt, 7);
            //Id,name,sex,signature,companyname,companyjob,trade,emailaddress,qq,city,sinablog,linkedin,skype,qqblog 
            char* emailaddress = (char*)sqlite3_column_text(stmt, 8);
            if (emailaddress)
                data.emailaddress = [NSString stringWithUTF8String:emailaddress];
            
            char* qq = (char*)sqlite3_column_text(stmt, 9);
            if (qq)
            {
                data.qq = [NSString stringWithUTF8String:qq];
            }
            
            data.city = (int)sqlite3_column_int(stmt, 10);
            
            char* sinablog = (char*)sqlite3_column_text(stmt, 11);
            if (sinablog)
                data.sinablog = [NSString stringWithUTF8String:sinablog];
            
            char* linkedin = (char*)sqlite3_column_text(stmt, 12);
            if (linkedin)
                data.linkedin = [NSString stringWithUTF8String:linkedin];
            char* skype = (char*)sqlite3_column_text(stmt, 13);
            if (skype)
                data.skype = [NSString stringWithUTF8String:skype];
            char* msn = (char*)sqlite3_column_text(stmt, 14);
            if (msn)
                data.msn = [NSString stringWithUTF8String:msn];
            data.soundflg = (int)sqlite3_column_int(stmt, 15);
            data.messageflg = (int)sqlite3_column_int(stmt, 16);
            data.showflg = (int)sqlite3_column_int(stmt, 17);
            data.companyno = (int)sqlite3_column_int(stmt, 18);
            [listData   addObject:data];
            
            break;
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
         sex:(int)sex
   signature:(NSString *)signature 
 companyno:(int)companyno
  companyjob:(int)companyjob
       trade:(int)trade
emailaddress:(NSString *)emailaddress
          qq:(NSString *)qq
        city:(int)city
    sinablog:(NSString *)sinablog
    linkedin:(NSString *)linkedin
       skype:(NSString *)skype
         msn:(NSString *)msn
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set name=?,sex=?,signature=?,companyno=?,companyjob=?,trade=?,emailaddress=?,qq=?,city=?,sinablog=?,linkedin=?,skype=?,msn=? where id = ?"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, sex);
    sqlite3_bind_text(stmt, 3, [signature UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, companyno);
    sqlite3_bind_int(stmt, 5, companyjob);
    sqlite3_bind_int(stmt, 6, trade);
    sqlite3_bind_text(stmt, 7, [emailaddress UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 8, [qq UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, city);
    sqlite3_bind_text(stmt, 10, [sinablog UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 11, [linkedin UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 12, [skype UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 13, [msn UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 14, no);
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
    
    NSString * sex = [dic objectForKey:@"性别:"];
    int set = [PBKbnMasterModel getKbnIdByName:sex withKind:@"sex"];
    NSString * trade = [dic objectForKey:@"行业划分:"];
    int strad = [PBKbnMasterModel getKbnIdByName:trade withKind:@"industry"];
    NSString * city = [dic objectForKey:@"所在城市:"];
    int city_ = [PBKbnMasterModel getKbnIdByName:city withKind:@"province"];
    NSString *idstr = [dic objectForKey:@"ID:"];
    int ID = idstr.intValue;
    int companyno = [[dic objectForKey:@"公司:"] intValue];
    int companyjob = [[dic objectForKey:@"companyjob"] intValue];
    [self SaveId:ID
            name:[dic objectForKey:@"姓名:"]
             sex:set
       signature:[dic objectForKey:@"个性签名:"]
       companyno:companyno
      companyjob:companyjob
           trade:strad
    emailaddress:[dic objectForKey:@"邮箱:"]
              qq:[dic objectForKey:@"QQ:"]
            city:city_
        sinablog:[dic objectForKey:@"新浪微博:"]
        linkedin:[dic objectForKey:@"Linkedln:"]
           skype:[dic objectForKey:@"Facebook:"]
             msn:[dic objectForKey:@"twitter:"]];
}
+(void)SaveImage1:(UIImage *)image userid:(int)userid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set imagepath = ? where id = ?"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, userid);
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
}
+(void)SaveSound:(int)soundno useid:(int)userid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set soundflg = ? where id = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    sqlite3_bind_int(stmt, 1, soundno);
    sqlite3_bind_int(stmt, 2, userid);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}
+(void)SaveMessage:(int)messageflg useid:(int)userid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set messageflg = ? where id = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    sqlite3_bind_int(stmt, 1, messageflg);
    sqlite3_bind_int(stmt, 2, userid);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}
+(void)SaveShow:(int)showflg useid:(int)userid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"update user set showflg = ? where id = ?"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
    }
    sqlite3_bind_int(stmt, 1, showflg);
    sqlite3_bind_int(stmt, 2, userid);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    //else
    //  no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}
@end
