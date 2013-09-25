//
//  PBShezhiData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBShezhiData : NSObject
+(NSMutableArray*)searchBy:(int)ID;
+(int)SaveId:(int)no 
        name:(NSString *)name 
         sex:(int)sex
        signature:(NSString *)signature 
       companyno:(int)companyno
        companyjob:(int )companyjob 
       trade:(int)trade
       emailaddress:(NSString *)emailaddress
       	qq:(NSString *)	qq
       city:(int)city
        sinablog:(NSString *)sinablog
        linkedin:(NSString *)linkedin
        skype:(NSString *)skype
        msn:(NSString *)msn;
+(void)saveRecord:(NSMutableDictionary *)dic;
+(void)SaveImage1:(UIImage *)image userid:(int)userid;
+(void)SaveImage:(UIImage *)image;
+(void)SaveSound:(int)soundno useid:(int)userid;
+(void)SaveShow:(int)showflg useid:(int)userid;
+(void)SaveMessage:(int)messageflg useid:(int)userid;
@property(nonatomic,readwrite)int no;
@property(nonatomic,retain,readwrite) UIImage* imagepath;
@property(nonatomic,retain,readwrite) NSString* name;
@property(nonatomic,readwrite) int sex;
@property(nonatomic,retain,readwrite) NSString* signature;
@property(nonatomic,retain,readwrite) NSString* companyname;
@property(nonatomic,readwrite) int companyjob;
@property(nonatomic,retain,readwrite) NSString* experience;
@property(nonatomic,readwrite) int trade;
@property(nonatomic,retain,readwrite) NSString* emailaddress;
@property(nonatomic,retain,readwrite) NSString* qq;
@property(nonatomic,readwrite) int city;
@property(nonatomic,retain,readwrite) NSString* sinablog;
@property(nonatomic,retain,readwrite) NSString* linkedin;
@property(nonatomic,retain,readwrite) NSString* skype;
@property(nonatomic,retain,readwrite) NSString* msn;
@property(nonatomic,readwrite)int soundflg;
@property(nonatomic,readwrite)int messageflg;
@property(nonatomic,readwrite)int showflg;
@property(nonatomic,readwrite)int companyno;
@end
