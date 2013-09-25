//
//  PBCompanyData.m
//  ParkBusiness
//
//  Created by QDS on 13-5-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBCompanyData.h"
static sqlite3* database = nil;

@implementation PBCompanyData

@synthesize no;
@synthesize parkno;
@synthesize name;
@synthesize accountname;
@synthesize address;
@synthesize companyaccount;
@synthesize image;
@synthesize bank;
@synthesize taxregistry;
@synthesize organizingcode;
@synthesize representative;
@synthesize telephone;
@synthesize actualoperatesite;
@synthesize averagerent;
@synthesize customerinfo;
@synthesize fixedassets;
@synthesize havefranchise;
@synthesize isfranchise;
@synthesize leasedate;
@synthesize mainproducts;
@synthesize receiptfund;
@synthesize registerfund;
@synthesize staffnum;
@synthesize totaldebt;
@synthesize tradeinfo;
@synthesize yearprofit;
@synthesize yearsale;
-(id)init
{
    self = [super init];
    if(self){
        no = -1;
    }
    return self;
}
+(PBCompanyData*)searchImageData:(int)userid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select a.no,a.name,a.image from companyinfo a left join user as b on b.companyno = a.no  where b.id = ?"]UTF8String];
    
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBCompanyData* data = [[[PBCompanyData alloc]init] autorelease];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, userid);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int i = 0;
            data.no = (int)sqlite3_column_int(stmt, i++);
            data.name = [data getStringData:stmt withColumn:i++];
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, i) length:(int)sqlite3_column_bytes(stmt, i++)];
            if (imageData) {
                data.image = [UIImage imageWithData:imageData];
            }
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return data;
    
}

+(PBCompanyData*)searchData:(int)userid
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"select a.no,a.parkno,a.name,a.image,taxregistry,organizingcode,representative,bank,companyaccount,accountname,a.telephone,a.address,staffnum,yearsale,fixedassets,yearprofit,totaldebt,registerfund,receiptfund,mainproducts,tradeinfo,customerinfo,actualoperatesite,leasedate,averagerent,isfranchise,havefranchise from companyinfo a left join user as b on b.companyno = a.no  where b.id = ?"]UTF8String];

    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return nil;
    }
    PBCompanyData* data = [[[PBCompanyData alloc]init] autorelease];
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, userid);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int i = 0;
            data.no = (int)sqlite3_column_int(stmt, i++);
            data.parkno = (int)sqlite3_column_int(stmt, i++);
            data.name = [data getStringData:stmt withColumn:i++];
            NSData *imageData = [NSData dataWithBytes:(const void *)sqlite3_column_blob(stmt, i) length:(int)sqlite3_column_bytes(stmt, i++)];
            if (imageData) {
                data.image = [UIImage imageWithData:imageData];
            }
            data.taxregistry = [data getStringData:stmt withColumn:i++];
            data.organizingcode = [data getStringData:stmt withColumn:i++];
            data.representative = [data getStringData:stmt withColumn:i++];
            data.bank = [data getStringData:stmt withColumn:i++];
            data.companyaccount = [data getStringData:stmt withColumn:i++];
            data.accountname = [data getStringData:stmt withColumn:i++];
            data.telephone = [data getStringData:stmt withColumn:i++];
            data.address = [data getStringData:stmt withColumn:i++];
            data.staffnum = (int)sqlite3_column_int(stmt, i++);
            data.yearsale = (int)sqlite3_column_int(stmt, i++);
            data.fixedassets = (int)sqlite3_column_int(stmt, i++);
            data.yearprofit = (int)sqlite3_column_int(stmt, i++);
            data.totaldebt = (int)sqlite3_column_int(stmt, i++);
            data.registerfund = (int)sqlite3_column_int(stmt, i++);
            data.receiptfund = (int)sqlite3_column_int(stmt, i++);
            data.mainproducts = [data getStringData:stmt withColumn:i++];
            data.tradeinfo = [data getStringData:stmt withColumn:i++];
            data.customerinfo = [data getStringData:stmt withColumn:i++];
            data.actualoperatesite = (int)sqlite3_column_int(stmt, i++);
            data.leasedate = (int)sqlite3_column_int(stmt, i)==0?@"":[NSDate dateWithTimeIntervalSince1970:(int)sqlite3_column_int(stmt, i)];
            i++;
            data.averagerent = (int)sqlite3_column_int(stmt, i++);
            data.isfranchise = (int)sqlite3_column_int(stmt, i++);
            data.havefranchise = (int)sqlite3_column_int(stmt, i++);
        }
    }else{
        
        NSAssert1(0, @"Error Select pages statement. '%s'", sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return data;
    
}

-(NSString*)getStringData:(sqlite3_stmt *)stmt withColumn:(int)col{
    char* str = (char*)sqlite3_column_text(stmt, col);
    if (str){
        return [NSString stringWithUTF8String:str];
    }
        return @"";
}

-(void)setImageData:(sqlite3_stmt *)stmt withColumn:(int)col withImage:(UIImage*)images{
    NSData *imageData;
    if (images) {
        imageData = UIImagePNGRepresentation(images);
        sqlite3_bind_blob(stmt, col, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
}

-(int)saveRecord
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into companyinfo(no,parkno,name,image,organizingcode,representative,bank,companyaccount,accountname,telephone,address,taxregistry,staffnum,yearsale,fixedassets,yearprofit,totaldebt,registerfund,receiptfund,mainproducts,tradeinfo,customerinfo,actualoperatesite,leasedate,averagerent,isfranchise,havefranchise,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    int i = 2;
    sqlite3_bind_int(stmt, i++, parkno);
    sqlite3_bind_text(stmt, i++, [name UTF8String],-1, SQLITE_TRANSIENT);
    [self setImageData:stmt withColumn:i++ withImage:image];
    sqlite3_bind_text(stmt, i++, [organizingcode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [representative UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [bank UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [companyaccount UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [accountname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [telephone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [address UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [taxregistry UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, i++, staffnum);
    sqlite3_bind_int(stmt, i++, yearsale);
    sqlite3_bind_int(stmt, i++, fixedassets);
    sqlite3_bind_int(stmt, i++, yearprofit);
    sqlite3_bind_int(stmt, i++, totaldebt);
    sqlite3_bind_int(stmt, i++, registerfund);
    sqlite3_bind_int(stmt, i++, receiptfund);
    sqlite3_bind_text(stmt, i++, [mainproducts UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [tradeinfo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [customerinfo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, i++, actualoperatesite);
    sqlite3_bind_int(stmt, i++, [leasedate timeIntervalSince1970]);
    sqlite3_bind_int(stmt, i++, averagerent);
    sqlite3_bind_int(stmt, i++, isfranchise);
    sqlite3_bind_int(stmt, i++, havefranchise);
    sqlite3_bind_int(stmt, i++, [[NSDate date] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, i++, [[NSDate date] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
-(NSMutableDictionary*)postDataToServer:(NSString*)mode{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",@"no",@"parkno",@"name",@"organizingcode",@"representative",@"bank",@"companyaccount",@"accountname",@"telephone",@"address",@"taxregistry",@"staffnum",@"yearsale",@"fixedassets",@"yearprofit",@"totaldebt",@"registerfund",@"receiptfund",@"mainproducts",@"tradeinfo",@"customerinfo",@"actualoperatesite",@"leasedate",@"averagerent",@"isfranchise",@"havefranchise", nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:mode,
                   [NSString stringWithFormat:@"%d",no],
                   [NSString stringWithFormat:@"%d",parkno?parkno:0],
                   name?name:@"",
                   organizingcode?organizingcode:@"",
                   representative?representative:@"",
                   bank?bank:@"",
                   companyaccount?companyaccount:@"",
                   accountname?accountname:@"",
                   telephone?telephone:@"",
                   address?address:@"",
                   taxregistry?taxregistry:@"",
                   [NSString stringWithFormat:@"%d",staffnum?staffnum:0],
                   [NSString stringWithFormat:@"%d",yearsale?yearsale:0],
                   [NSString stringWithFormat:@"%d",fixedassets?fixedassets:0],
                   [NSString stringWithFormat:@"%d",yearprofit?yearprofit:0],
                   [NSString stringWithFormat:@"%d",totaldebt?totaldebt:0],
                   [NSString stringWithFormat:@"%d",registerfund?registerfund:0],
                   [NSString stringWithFormat:@"%d",receiptfund?receiptfund:0],
                   mainproducts?mainproducts:@"",
                   tradeinfo?tradeinfo:@"",
                   customerinfo?customerinfo:@"",
                   [NSString stringWithFormat:@"%d",actualoperatesite?actualoperatesite:0],
                   [formatter stringFromDate:leasedate]?[formatter stringFromDate:leasedate]:@"0",
                   [NSString stringWithFormat:@"%d",averagerent?averagerent:0],
                   [NSString stringWithFormat:@"%d",isfranchise?isfranchise:0],
                   [NSString stringWithFormat:@"%d",havefranchise?havefranchise:0],
                   nil];
    return [[NSMutableDictionary alloc]initWithObjects:a2 forKeys:a1];
}
@end
