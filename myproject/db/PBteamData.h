//
//  PBteamData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBteamData : NSObject
+(NSMutableArray*)searchWhereProjectno:(int)projectno;
+(int)SaveId:(int)no 
        name:(NSString *)name 
        teamjob:(int)teamjob
        introduce:(NSString *)introduce 
        years:(NSString *)years
        married:(NSString *)married 
        experience:(NSString *)experience
        projectno:(int)projectno
        companyno:(int)companyno
       imagepath:(UIImage *)imagepath;
        
-(void)saveRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,retain,readwrite) NSString* name;
@property(nonatomic,readwrite) int teamjob;
@property(nonatomic,retain,readwrite) NSString* introduce;
@property(nonatomic,retain,readwrite) NSString* years;
@property(nonatomic,retain,readwrite) NSString* married;
@property(nonatomic,retain,readwrite) NSString* experience;
@property(nonatomic,retain,readwrite)  UIImage *imagepath;
@property(nonatomic,readwrite) int projectno;
@property(nonatomic,readwrite)int companyno;
@end
