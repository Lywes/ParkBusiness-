//
//  PBProjectData.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBProjectData : NSObject
+(NSMutableArray*)search;
+(PBProjectData*)searchImagePath:(int)projectno;
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
  softwareno:(NSString *)softwareno;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
+(int)SaveImage1:(UIImage *)image ID:(int)no;
+(NSMutableArray*)searchAllProjectData;
-(void)SaveImage;
@property(nonatomic,readwrite)int no;
@property(nonatomic,retain,readwrite) NSString* proname;
@property(nonatomic,readwrite) int trade;
@property(nonatomic,retain,readwrite) NSString* introduce;
@property(nonatomic,retain,readwrite) UIImage* imagepath;
@property(nonatomic,retain,readwrite) NSString* stdate;
@property(nonatomic,readwrite) int stage;
@property(nonatomic,readwrite)int modetype;
@property(nonatomic,retain,readwrite)NSString* businessmode;
@property(nonatomic,retain,readwrite)NSString* financingamount;
@property(nonatomic,readwrite)int amountunit;
@property(nonatomic,readwrite)int rate;
@property(nonatomic,retain,readwrite)NSString* 	others;
@property(nonatomic,readwrite)int companyno;
@property(nonatomic,readwrite)int type;
@property(nonatomic,retain,readwrite)NSString* 	productadvantage;
@property(nonatomic,retain,readwrite)NSString* 	potentialrisk;
@property(nonatomic,retain,readwrite)NSString* softwareno;
@property(nonatomic,retain,readwrite)NSString* plantname;
@property(nonatomic,retain,readwrite)NSString* diagramno;
@end
