//
//  PBInsertDataModel.m
//  ParkBusiness
//
//  Created by QDS on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInsertDataModel.h"
static sqlite3* database = nil;
@implementation PBInsertDataModel
-(id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}
//保存user信息
+(int)saveUserRecords:(NSDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    // NSLog(dbPath);
    int no = -1;
    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",@"insert or replace into user(id,identifier,kind,parkno,name,sex,imagepath,companyjob,emailaddress,companyno,trade,password,signature,qq,tel,msn,skype,sinablog,linkedin,qqblog,city,superflg,logintime,investtrade,investsubdivision,annualinvestno,projectfund_avg,carveoutresourse,projectname,financingyear,financingmonth,financingmoney,moneyunit,likestage,joinage,sketch,recommendstate,activeflg,showflg,messageflg,soundflg,themeid,tutorflg,udate,cdate,fundscale,credit",@") Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
        return -1;
    }
    if (sqlite3_prepare_v2(database, sql, -1, &stmt, NULL)!= SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'", sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return no;
    }
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_text(stmt, 2, [[dic objectForKey:@"identifier"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"kind"] intValue]);
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"parkno"] intValue]);
    sqlite3_bind_text(stmt, 5, [[dic objectForKey:@"name"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"sex"] intValue]);
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]]]];
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 7, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 8, [[dic objectForKey:@"companyjob"] intValue]);
    sqlite3_bind_text(stmt, 9, [[dic objectForKey:@"emailaddress"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 10, [[dic objectForKey:@"companyno"]  UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 11, [[dic objectForKey:@"trade"] intValue]);
    sqlite3_bind_text(stmt, 12, [[dic objectForKey:@"password"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 13, [[dic objectForKey:@"signature"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 14, [[dic objectForKey:@"qq"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 15, [[dic objectForKey:@"tel"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 16, [[dic objectForKey:@"msn"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 17, [[dic objectForKey:@"skype"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 18, [[dic objectForKey:@"sinablog"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 19, [[dic objectForKey:@"linkedin"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 20, [[dic objectForKey:@"qqblog"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 21, [[dic objectForKey:@"city"] intValue]);
    sqlite3_bind_int(stmt, 22, [[dic objectForKey:@"superflg"] intValue]);
    sqlite3_bind_int(stmt, 23, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"logintime"]] timeIntervalSince1970]);
    sqlite3_bind_text(stmt, 24, [[dic objectForKey:@"investtrade"]  UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 25, [[dic objectForKey:@"investsubdivision"]  UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 26, [[dic objectForKey:@"annualinvestno"] intValue]);
    sqlite3_bind_int(stmt, 27, [[dic objectForKey:@"projectfund_avg"] intValue]);
    sqlite3_bind_text(stmt, 28, [[dic objectForKey:@"carveoutresourse"]  UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 29, [[dic objectForKey:@"projectname"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 30, [[dic objectForKey:@"financingyear"] intValue]);
    sqlite3_bind_int(stmt, 31, [[dic objectForKey:@"financingmonth"] intValue]);
    sqlite3_bind_int(stmt, 32, [[dic objectForKey:@"financingmoney"] intValue]);
    sqlite3_bind_int(stmt, 33, [[dic objectForKey:@"moneyunit"] intValue]);
    sqlite3_bind_int(stmt, 34, [[dic objectForKey:@"likestage"] intValue]);
    sqlite3_bind_int(stmt, 35, [[dic objectForKey:@"joinage"] intValue]);
    sqlite3_bind_text(stmt, 36, [[dic objectForKey:@"sketch"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 37, [[dic objectForKey:@"recommendstate"] intValue]);
    sqlite3_bind_int(stmt, 38, [[dic objectForKey:@"activeflg"] intValue]);
    sqlite3_bind_int(stmt, 39, [[dic objectForKey:@"showflg"] intValue]);
    sqlite3_bind_int(stmt, 40, [[dic objectForKey:@"messageflg"] intValue]);
    sqlite3_bind_int(stmt, 41, [[dic objectForKey:@"soundflg"] intValue]);
    sqlite3_bind_int(stmt, 42, [[dic objectForKey:@"themeid"] intValue]);
    sqlite3_bind_int(stmt, 43, [[dic objectForKey:@"tutorflg"] intValue]);
    sqlite3_bind_int(stmt, 44, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 45, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 46, [[dic objectForKey:@"fundscale"] intValue]);
    sqlite3_bind_int(stmt, 47, [[dic objectForKey:@"credit"] intValue]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
//保存projectinfo信息
+(int)saveProjectInfoRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectinfo(no,proname,trade,introduce,stdate,stage,modetype,businessmode,financingamount,amountunit,rate,others,imagepath,type,softwareno,plantname,diagramno,productadvantage,potentialrisk) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_text(stmt, 2, [[dic objectForKey:@"proname"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, [[dic objectForKey:@"trade"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 4, [[dic objectForKey:@"introduce"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"stdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"stage"] intValue]);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"modetype"] intValue]);
    sqlite3_bind_text(stmt, 8, [[dic objectForKey:@"businessmode"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, [[dic objectForKey:@"financingamount"] intValue]);
    sqlite3_bind_int(stmt, 10, [[dic objectForKey:@"amountunit"] intValue]);
    sqlite3_bind_int(stmt, 11, [[dic objectForKey:@"rate"] intValue]);
    sqlite3_bind_text(stmt, 12, [[dic objectForKey:@"others"] UTF8String], -1, SQLITE_TRANSIENT);
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]]]];
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 13, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 14, [[dic objectForKey:@"type"] intValue]);
    sqlite3_bind_text(stmt, 15, [[dic objectForKey:@"softwareno"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 16, [[dic objectForKey:@"plantname"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 17, [[dic objectForKey:@"diagramno"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 18, [[dic objectForKey:@"productadvantage"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 19, [[dic objectForKey:@"potentialrisk"] UTF8String], -1, SQLITE_TRANSIENT);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
//保存project信息
+(int)saveProjectRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into project(no,projectinfono,personno,ycno,name,projectintroduce,projectstage,trade,submarket,money,moneyunit,share,homepageurl,starttime,teamintroduce,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectinfono"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"personno"] intValue]);
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"ycno"] intValue]);
    sqlite3_bind_text(stmt, 5, [[dic objectForKey:@"name"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 6, [[dic objectForKey:@"projectintroduce"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"projectstage"] intValue]);
    sqlite3_bind_int(stmt, 8, [[dic objectForKey:@"trade"] intValue]);
    sqlite3_bind_text(stmt, 9, [[dic objectForKey:@"submarket"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 10, [[dic objectForKey:@"money"] intValue]);
    sqlite3_bind_int(stmt, 11, [[dic objectForKey:@"moneyunit"] intValue]);
    sqlite3_bind_int(stmt, 12, [[dic objectForKey:@"share"] intValue]);
    sqlite3_bind_text(stmt,13, [[dic objectForKey:@"homepageurl"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 14, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"starttime"]] timeIntervalSince1970]);
    sqlite3_bind_text(stmt, 15, [[dic objectForKey:@"teamintroduce"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 16, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 17, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存projectgroup信息
+(int)saveProjectGroupRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectgroup(no,projectno,companyno,imagepath,teamjob,name,years,experience,introduce,married,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"companyno"] intValue]);
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]]]];
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 4, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"teamjob"] intValue]);
    sqlite3_bind_text(stmt, 6, [[dic objectForKey:@"name"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"years"] intValue]);
    sqlite3_bind_text(stmt, 8, [[dic objectForKey:@"experience"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 9, [[dic objectForKey:@"introduce"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 10, [[dic objectForKey:@"married"] intValue]);
    sqlite3_bind_int(stmt, 11, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 12, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存projectplan信息
+(int)saveProjectPlanRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectplan(no,projectno,companyno,stdate,enddate,totalbudget,salestarget,profittarget,teambiulding,productdev,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"companyno"] intValue]);
    sqlite3_bind_int(stmt, 4, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"stdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 5, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"enddate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"totalbudget"] intValue]);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"salestarget"] intValue]);
    sqlite3_bind_int(stmt, 8, [[dic objectForKey:@"profittarget"] intValue]);
    sqlite3_bind_text(stmt, 9, [[dic objectForKey:@"teambiulding"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 10, [[dic objectForKey:@"productdev"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 11, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 12, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存projectcondition信息
+(int)saveProjectConditionRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into projectcondition(no,projectno,condition,cdate,udate) Values(?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_text(stmt, 3, [[dic objectForKey:@"condition"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 4, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 5, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存investexperience信息
+(int)saveInvestExperienceRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into investexperience(no,projectno,investstage,investamount,amountunit,companyname,investors,financetime,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"investstage"] intValue]);
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"investamount"] intValue]);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"amountunit"] intValue]);
    sqlite3_bind_text(stmt, 6, [[dic objectForKey:@"companyname"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 7, [[dic objectForKey:@"investors"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 8, [[dic objectForKey:@"financetime"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 10, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存friend信息
+(int)saveFriendRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into friend(id,signature,friendid,friendname,icon,imgpath) Values(?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_text(stmt, 2, [[dic objectForKey:@"signature"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"fid"] intValue]);
    sqlite3_bind_text(stmt, 4, [[dic objectForKey:@"username"] UTF8String],-1, SQLITE_TRANSIENT);
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"list_addfriend_icon.png"]);
    sqlite3_bind_blob(stmt, 5, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 6, [[dic objectForKey:@"imgpath"] UTF8String], -1, SQLITE_TRANSIENT);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存groupmaster信息
+(int)saveGroupRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into groupmaster(id,groupid,groupname) Values(?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"gid"] intValue]);
    sqlite3_bind_text(stmt, 3, [[dic objectForKey:@"groupname"] UTF8String],-1, SQLITE_TRANSIENT);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
//保存companyinfo表信息
+(int)saveCompanyInfoRecord:(NSMutableDictionary*)dic
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    int i = 2;
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"parkno"] intValue]);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"name"] UTF8String],-1, SQLITE_TRANSIENT);
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]]]];
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, i++, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }else{
        i++;
    }
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"organizingcode"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"representative"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"bank"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"companyaccount"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"accountname"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"telephone"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"address"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"taxregistry"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"staffnum"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"yearsale"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"fixedassets"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"yearprofit"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"totaldebt"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"registerfund"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"receiptfund"] intValue]);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"mainproducts"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"tradeinfo"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, i++, [[dic objectForKey:@"customerinfo"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"actualoperatesite"] intValue]);
    sqlite3_bind_int(stmt, i++, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"leasedate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"averagerent"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"isfranchise"] intValue]);
    sqlite3_bind_int(stmt, i++, [[dic objectForKey:@"havefranchise"] intValue]);
    sqlite3_bind_int(stmt, i++, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, i++, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存bankloaninfo表信息
+(int)saveBankLoanRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into bankloaninfo(no,projectno,securedform,applyloan,loanlimit,yearraterange,loanuse,others,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"securedform"] intValue]);
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"applyloan"] intValue]);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"loanlimit"] intValue]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"yearraterange"] intValue]);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"loanuse"] intValue]);
    sqlite3_bind_text(stmt, 8, [[dic objectForKey:@"others"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 10, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存companybondinfo表信息
+(int)saveCompanyBondRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into companybondinfo(no,companyno,imagepath,bondtype,issueamount,bondamount,yearprofit,debttoequity,others,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"companyno"] intValue]);
    NSData *imageData;
    UIImage* image = [UIImage imageNamed:@"boss.png"];
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 3, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"bondtype"] intValue]);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"issueamount"] intValue]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"bondamount"] intValue]);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"yearprofit"] intValue]);
    sqlite3_bind_int(stmt, 8, [[dic objectForKey:@"debttoequity"] intValue]);
    sqlite3_bind_text(stmt, 9, [[dic objectForKey:@"others"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 10, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 11, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存financingassure表信息
+(int)saveFinancingAssureRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into financingassure(no,loanapply,applyproperty,enterprise,creditamount,creditlimit,repaytype,loanbankname,applycredituse,assurerate,imagepath,companyno,cdate,udate) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_text(stmt, 2, [[dic objectForKey:@"loanapply"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"applyproperty"] intValue]);
    sqlite3_bind_text(stmt, 4, [[dic objectForKey:@"enterprise"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"creditamount"] intValue]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"creditlimit"] intValue]);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"repaytype"] intValue]);
    sqlite3_bind_text(stmt, 8, [[dic objectForKey:@"loanbankname"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 9, [[dic objectForKey:@"applycredituse"] intValue]);
    sqlite3_bind_int(stmt, 10, [[dic objectForKey:@"assurerate"] intValue]);
    NSData *imageData;
    UIImage* image = [UIImage imageNamed:@"boss.png"];
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 11, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 12, [[dic objectForKey:@"companyno"] intValue]);
    sqlite3_bind_int(stmt, 13, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 14, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;

}

//保存financinglease表信息
+(int)saveFinancingLeaseRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into financinglease(no,companyno,imagepath,type,projectamount,receiptfund,leasedeviceinfo,cdate,udate) Values(?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"companyno"] intValue]);
    NSData *imageData;
    UIImage* image = [UIImage imageNamed:@"boss.png"];
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 3, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"type"] intValue]);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"projectamount"] intValue]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"receiptfund"] intValue]);
    sqlite3_bind_text(stmt, 7, [[dic objectForKey:@"leasedeviceinfo"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 8, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 9, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

//保存patentinfo表信息
+(int)savePatentInfoRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into patentinfo(no,projectno,type,name,patentno,acceptdate,authorizedate,cdate,udate) Values(?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"type"] intValue]);
    sqlite3_bind_text(stmt, 4, [[dic objectForKey:@"name"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [[dic objectForKey:@"patentno"] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"acceptdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 7, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"authorizedate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 8, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 9, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}

////保存financingleaseaccount表信息
+(int)saveFinancingAccountRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into financingleaseaccount(no,projectno,	year,assetamount,responseamount,netasset,assetdebtrate,salesrevenue,pretaxprofit,aftertaxprofit,activitycashflow,others,cdate,udate,type) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"projectno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"year"] intValue]);
    sqlite3_bind_int(stmt, 4, [[dic objectForKey:@"assetamount"] intValue]);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"responseamount"] intValue]);
    sqlite3_bind_int(stmt, 6, [[dic objectForKey:@"netasset"] intValue]);
    sqlite3_bind_int(stmt, 7, [[dic objectForKey:@"assetdebtrate"] intValue]);
    sqlite3_bind_int(stmt, 8, [[dic objectForKey:@"salesrevenue"] intValue]);
    sqlite3_bind_int(stmt, 9, [[dic objectForKey:@"pretaxprofit"] intValue]);
    sqlite3_bind_int(stmt, 10, [[dic objectForKey:@"aftertaxprofit"] intValue]);
    sqlite3_bind_int(stmt, 11, [[dic objectForKey:@"activitycashflow"] intValue]);
    sqlite3_bind_text(stmt, 12, [[dic objectForKey:@"others"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 13, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 14, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 15, [[dic objectForKey:@"type"] intValue]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
////保存bankfinancingcase表信息
+(int)saveBankFinancingCaseRecord:(NSMutableDictionary *)dic{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
    sqlite3_stmt *stmt = nil;
    int no = -1;
    const char *sql = [[NSString stringWithFormat:@"%@",@"insert or replace into bankfinancingcase(no,userno,type,name,companyno,companyinfo,imagepath,trade,casedetail,cdate,udate,type) Values(?,?,?,?,?,?,?,?,?,?,?,?)"]UTF8String];
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
    sqlite3_bind_int(stmt, 1, [[dic objectForKey:@"no"] intValue]);
    sqlite3_bind_int(stmt, 2, [[dic objectForKey:@"userno"] intValue]);
    sqlite3_bind_int(stmt, 3, [[dic objectForKey:@"type"] intValue]);
    sqlite3_bind_text(stmt, 4, [[dic objectForKey:@"name"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 5, [[dic objectForKey:@"companyno"] intValue]);
    sqlite3_bind_text(stmt, 6, [[dic objectForKey:@"companyinfo"] UTF8String],-1, SQLITE_TRANSIENT);
    NSData *imageData;
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,[dic objectForKey:@"imagepath"]]]]];
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 7, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 8, [[dic objectForKey:@"trade"] intValue]);
    sqlite3_bind_text(stmt, 9, [[dic objectForKey:@"casedetail"] UTF8String],-1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 10, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"cdate"]] timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 11, [[PBInsertDataModel convertDateFromString:[dic objectForKey:@"udate"]] timeIntervalSince1970]);
    if (SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
    else
        no = sqlite3_last_insert_rowid(database);
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return no;
}
//转换时间类型
+(NSDate*)convertDateFromString:(NSString*)string{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate* date = [formatter dateFromString:string];
    [formatter release];
    return date;
    
}
@end
