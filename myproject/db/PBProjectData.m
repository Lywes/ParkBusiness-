//
//  PBProjectData.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectData.h"
#import "PBFinanceAccountData.h"
#import "PBCompanyBondData.h"
#import "PBFinanceAssureData.h"
#import "PBFinanceLeaseData.h"
static sqlite3* database = nil;
@implementation PBProjectData
@synthesize no,proname,trade,introduce,imagepath,stdate,stage,modetype,businessmode,financingamount,amountunit,rate,others,companyno,type,productadvantage,potentialrisk,diagramno,plantname,softwareno;

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
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,proname,trade,introduce,imagepath,stdate,stage,modetype,businessmode,financingamount,amountunit,rate,others,companyno,type,productadvantage,potentialrisk,diagramno,plantname,softwareno from projectinfo "]UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];

    // [listData retain];
   
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
          PBProjectData* data = [[[PBProjectData alloc]init] autorelease];   
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* proname = (char*)sqlite3_column_text(stmt, 1);
            if (proname)
                data.proname = [NSString stringWithUTF8String:proname];
                data.trade = (int)sqlite3_column_int(stmt, 2);
            char* introduce = (char*)sqlite3_column_text(stmt, 3);
            if (introduce)
                data.introduce = [NSString stringWithUTF8String:introduce];
            
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 4) length:(int)sqlite3_column_bytes(stmt, 4)];
            if (imageData) {
                data.imagepath = [UIImage imageWithData:imageData];
            }
            
            char* stdate = (char*)sqlite3_column_text(stmt, 5);
            if (stdate)
            {
                data.stdate = [NSString stringWithUTF8String:stdate];
            }
            
                data.stage = (int)sqlite3_column_int(stmt, 6);
                data.modetype = (int)sqlite3_column_int(stmt, 7);
            
            char* businessmode = (char*)sqlite3_column_text(stmt, 8);
            if (businessmode)
                data.businessmode = [NSString stringWithUTF8String:businessmode];
            
            char* financingamount = (char*)sqlite3_column_text(stmt, 9);
            
            if (financingamount)
            {
                data.financingamount = [NSString stringWithUTF8String:financingamount];
            }
            
            data.amountunit = (int)sqlite3_column_int(stmt, 10);
            data.rate = (int)sqlite3_column_int(stmt, 11);
            
            char* others = (char*)sqlite3_column_text(stmt, 12);
            if (others)
                data.others = [NSString stringWithUTF8String:others];
            data.companyno = (int)sqlite3_column_int(stmt, 13);
            data.type = (int)sqlite3_column_int(stmt, 14);
            char* productadvantage = (char*)sqlite3_column_text(stmt, 15);
            if (productadvantage)
                data.productadvantage = [NSString stringWithUTF8String:productadvantage];
            char* potentialrisk = (char*)sqlite3_column_text(stmt, 16);
            if (potentialrisk)
                data.potentialrisk = [NSString stringWithUTF8String:potentialrisk];
            char* diagramno = (char*)sqlite3_column_text(stmt, 17);
            if (diagramno)
                data.diagramno = [NSString stringWithUTF8String:diagramno];
            char* plantname = (char*)sqlite3_column_text(stmt, 18);
            if (plantname)
                data.plantname = [NSString stringWithUTF8String:plantname];
            char* softwareno = (char*)sqlite3_column_text(stmt, 19);
            if (softwareno)
                data.softwareno = [NSString stringWithUTF8String:softwareno];
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
+(PBProjectData*)searchImagePath:(int)projectno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,proname,trade,introduce,imagepath,stdate,stage,modetype,businessmode,financingamount,amountunit,rate,others,companyno,type,productadvantage,potentialrisk,diagramno,plantname,softwareno from projectinfo where no = ?"]UTF8String];
//    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
    // [listData retain];
    
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBProjectData* data = [[[PBProjectData alloc]init] autorelease];   
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, projectno);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* proname = (char*)sqlite3_column_text(stmt, 1);
            if (proname)
                data.proname = [NSString stringWithUTF8String:proname];
            
            data.trade = (int)sqlite3_column_int(stmt, 2);
            char* introduce = (char*)sqlite3_column_text(stmt, 3);
            if (introduce)
                data.introduce = [NSString stringWithUTF8String:introduce];
            
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 4) length:(int)sqlite3_column_bytes(stmt, 4)];
            if (imageData) {
                data.imagepath = [UIImage imageWithData:imageData];
            }
            
            char* stdate = (char*)sqlite3_column_text(stmt, 5);
            if (stdate)
            {
                data.stdate = [NSString stringWithUTF8String:stdate];
            }
            data.stage = (int)sqlite3_column_int(stmt, 6);
            data.modetype = (int)sqlite3_column_int(stmt, 7);
            
            char* businessmode = (char*)sqlite3_column_text(stmt, 8);
            if (businessmode)
                data.businessmode = [NSString stringWithUTF8String:businessmode];
            
            char* financingamount = (char*)sqlite3_column_text(stmt, 9);
            if (financingamount)
                {
                    data.financingamount = [NSString stringWithUTF8String:financingamount];
                }

            data.amountunit = (int)sqlite3_column_int(stmt, 10);
            data.rate = (int)sqlite3_column_int(stmt, 11);
            
            char* others = (char*)sqlite3_column_text(stmt, 12);
            if (others)
                data.others = [NSString stringWithUTF8String:others];
            data.companyno = (int)sqlite3_column_int(stmt, 13);
            data.type = (int)sqlite3_column_int(stmt, 14);
            char* productadvantage = (char*)sqlite3_column_text(stmt, 15);
            if (productadvantage)
                data.productadvantage = [NSString stringWithUTF8String:productadvantage];
            char* potentialrisk = (char*)sqlite3_column_text(stmt, 16);
            if (potentialrisk)
                data.potentialrisk = [NSString stringWithUTF8String:potentialrisk];
            char* diagramno = (char*)sqlite3_column_text(stmt, 17);
            if (diagramno)
                data.diagramno = [NSString stringWithUTF8String:diagramno];
            char* plantname = (char*)sqlite3_column_text(stmt, 18);
            if (plantname)
                data.plantname = [NSString stringWithUTF8String:plantname];
            char* softwareno = (char*)sqlite3_column_text(stmt, 19);
            if (softwareno)
                data.softwareno = [NSString stringWithUTF8String:softwareno];
//            [listData   addObject:data];
            
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return data;
}
+(NSMutableArray*)searchAllProjectData
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select no,proname as name,type,imagepath,udate from projectinfo union select a.no,ifnull(b.name,'')||'期债券发行' as name,3 as type,a.imagepath,a.udate from companybondinfo a left join kbn_master as b on b.id = a.bondtype and b.kind = 'bondtype' union select no,ifnull(loanbankname,'')||'银行'||ifnull(creditamount,0)||'万元贷款担保申请' as name,4 as type,imagepath,udate from financingassure union select a.no,a.projectamount||'万元'||ifnull(b.name,'')||'金融租赁项目' as name,5 as type,a.imagepath,a.udate from financinglease a left join kbn_master as b on b.id = a.type and b.kind = 'leasetype' order by udate desc"] UTF8String];
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    
    // [listData retain];
    
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PBProjectData* data = [[[PBProjectData alloc]init] autorelease];
            data.no = (int)sqlite3_column_int(stmt, 0);
            
            char* proname = (char*)sqlite3_column_text(stmt, 1);
            if (proname)
                data.proname = [NSString stringWithUTF8String:proname];
            data.type = (int)sqlite3_column_int(stmt, 2);
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, 3) length:(int)sqlite3_column_bytes(stmt, 3)];
            if (imageData) {
                data.imagepath = [UIImage imageWithData:imageData];
            }
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
+(int)saveId:(int)no
     proname:(NSString*)proname
       trade:(int)trade
   introduce:(NSString*)introduce
      stdate:(NSString*)stdate
       stage:(int)stage 
    modetype:(int)modetype
businessmode:(NSString *)businessmode 
financingamount:(NSString *)financingamount 
  amountunit:(int)amountunit
        rate:(int)rate  
      others:(NSString *)others 
    image:(UIImage *)image
companyno:(int)companyno
type:(int)type
productadvantage:(NSString *)productadvantage 
potentialrisk:(NSString *)potentialrisk
diagramno:(NSString *)diagramno
plantname:(NSString *)plantname
softwareno:(NSString *)softwareno
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectinfo(no,proname,trade,introduce,stdate,stage,modetype,businessmode,financingamount,amountunit,rate,others,imagepath,companyno,type,productadvantage,potentialrisk,diagramno,plantname,softwareno,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_text(stmt, 2, [proname UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, trade);
    sqlite3_bind_text(stmt, 4, [introduce UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [stdate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, stage);
    sqlite3_bind_int(stmt, 7, modetype);
    sqlite3_bind_text(stmt, 8, [businessmode UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_text(stmt, 9, [financingamount UTF8String], -1, SQLITE_TRANSIENT);
     sqlite3_bind_int(stmt, 10, amountunit);
     sqlite3_bind_int(stmt, 11, rate);
     sqlite3_bind_text(stmt, 12, [others UTF8String], -1, SQLITE_TRANSIENT);
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 13, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 14, companyno);
    sqlite3_bind_int(stmt, 15, type);
    sqlite3_bind_text(stmt, 16, [productadvantage UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 17, [potentialrisk UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 18, [diagramno UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 19, [plantname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 20, [softwareno UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 21, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 22, [[NSDate date] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
      no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
-(void)saveRecord
{
    no = [PBProjectData saveId:self.no proname:self.proname trade:self.trade introduce:self.introduce  stdate:self.stdate stage:self.stage modetype:self.modetype businessmode:self.businessmode financingamount:self.financingamount amountunit:self.amountunit rate:self.rate others:self.others image:self.imagepath companyno:self.companyno type:self.type productadvantage:self.productadvantage potentialrisk:self.potentialrisk diagramno:self.diagramno plantname:self.plantname softwareno:self.softwareno];
}
+(void)deleteId:(int)recordId
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from projectinfo where no = ?  ";
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
+(void)deleteWithProjectno:(int)recordId fromTable:(NSString*)table
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"delete from %@ where projectno = ?  ",table] UTF8String];
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
    switch (type) {
        case 1:
            [PBProjectData deleteId:no];
            [PBProjectData deleteWithProjectno:no fromTable:@"projectplan"];
            [PBProjectData deleteWithProjectno:no fromTable:@"projectgroup"];
            [PBProjectData deleteWithProjectno:no fromTable:@"projectcondition"];
            [PBProjectData deleteWithProjectno:no fromTable:@"investexperience"];
            [PBProjectData deleteWithProjectno:no fromTable:@"patentinfo"];
            [PBFinanceAccountData deleteWithProjectno:no withType:type];
            break;
        case 2:
            [PBProjectData deleteId:no];
            [PBProjectData deleteWithProjectno:no fromTable:@"bankloaninfo"];
            break;
        case 3:
            [PBCompanyBondData deleteRecord:no];
            break;
        case 4:
            [PBFinanceAssureData deleteRecord:no];
            break;
        case 5:
            [PBFinanceLeaseData deleteRecord:no];
            [PBFinanceAccountData deleteWithProjectno:no withType:type];
            break;
        default:
            break;
    }
    
}
+(int)SaveImage1:(UIImage *)image ID:(int)no
    
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"insert or replace into projectinfo(no,imagepath) Values(?,?) "]UTF8String];
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
    if (no == -1|| no == 0) {
        
    }else{
        sqlite3_bind_int(stmt, 2, no);
    }

    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    
    no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
-(void)SaveImage
{
    no = [PBProjectData SaveImage1:self.imagepath ID:self.no];
}
-(PBProjectData*)getdata:(NSMutableDictionary*)dic{
    PBProjectData* data = [[PBProjectData alloc]init];
    data.proname = [dic objectForKey:@"projectname"];
    return data;
}
@end
