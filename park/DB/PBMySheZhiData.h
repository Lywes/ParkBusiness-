//
//  PBMySheZhiData.h
//  ParkBusiness
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBMySheZhiData : NSObject
+(NSMutableArray*)search;
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
         msn:(NSString *)msn;

+(void)saveRecord:(NSMutableDictionary *)dic;
+(void)SaveImage1:(UIImage *)image;
+(void)SaveImage:(UIImage *)image;
@property(nonatomic,readwrite)int no;
@property(nonatomic,retain,readwrite) UIImage* imagepath;
@property(nonatomic,retain,readwrite) NSString* name;
@property(nonatomic,retain,readwrite) NSString* sex;
@property(nonatomic,retain,readwrite) NSString* signature;
@property(nonatomic,retain,readwrite) NSString* companyname;
@property(nonatomic,retain,readwrite) NSString* companyjob;
@property(nonatomic,retain,readwrite) NSString* emailaddress;
@property(nonatomic,retain,readwrite) NSString* qq;
@property(nonatomic,retain,readwrite) NSString* city;
@property(nonatomic,retain,readwrite) NSString* sinablog;
@property(nonatomic,retain,readwrite) NSString* linkedin;
@property(nonatomic,retain,readwrite) NSString* skype;
@property(nonatomic,retain,readwrite) NSString* msn;
@end
