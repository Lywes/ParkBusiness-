//
//  PBPlanData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBPlanData : NSObject
+(NSMutableArray*)searchWhereProjectno:(int)projectno;
+(int)SaveId:(int)no 
      stdate:(NSString *)stdate  
      enddate:(NSString *)enddate 
     totalbudget:(NSString *)totalbudget 
   salestarget:(NSString *)salestarget 
       profittarget:(NSString *)profittarget
     teambiulding:(NSString *)teambiulding 
  productdev:(NSString *)productdev  
    prjectno:(int)projectno
    companyno:(int)companyno;
-(void)saveRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite)int companyno;
@property(nonatomic,readwrite)int projectno;
@property(nonatomic,retain,readwrite) NSString* stdate;
@property(nonatomic,retain,readwrite) NSString* enddate;
@property(nonatomic,retain,readwrite) NSString* totalbudget;
@property(nonatomic,retain,readwrite) NSString* salestarget;
@property(nonatomic,retain,readwrite) NSString* profittarget;
@property(nonatomic,retain,readwrite) NSString* teambiulding;
@property(nonatomic,retain,readwrite) NSString* productdev;
@end
