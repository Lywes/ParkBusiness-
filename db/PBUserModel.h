//
//  PBUserData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBUserModel : NSObject
+(BOOL)isRegister;
+(int)getParkNo;
+(int)getUserId;
+(int)getCompanyno;
+(NSString*)getTel;
+(int)getVersion;
+(PBUserModel*)getPasswordAndKind;
-(void)saveRecord;
+(int)updateKind:(int)kind;
+(int)updateCompanyno:(int)companyno;
-(void)deleteRecord;
+(int)updateCredit:(int)credit;
+(int)getCredit;
+(BOOL)executeWithSql:(NSString*)executeSql;
@property(nonatomic,retain,readwrite) NSString* tel;
@property(nonatomic,readwrite) int userId;
@property(nonatomic,retain,readwrite)NSString* password;
@property(nonatomic,readwrite) int kind;
@end
