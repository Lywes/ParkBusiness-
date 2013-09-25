//
//  PBFinanceAccountData.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBFinanceAccountData : NSObject
+(int)saveId:(int)no
type:(int)type
projectno:(int)projectno
year:(int)year
assetamount:(int)assetamount
responseamount:(int)responseamount
netasset:(int)netasset
assetdebtrate:(int)assetdebtrate
salesrevenue:(int)salesrevenue
pretaxprofit:(int)pretaxprofit
aftertaxprofit:(int)aftertaxprofit
activitycashflow:(int)activitycashflow
      others:(NSString*)others;
-(void)saveRecord;
+(NSMutableArray*)searchData:(int)projectno withyear:(int)year withType:(int)type;
+(void)deleteWithProjectno:(int)recordId withType:(int)type_;
@property(nonatomic,assign) int no;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int projectno;
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int assetamount;
@property(nonatomic,assign) int responseamount;
@property(nonatomic,assign) int netasset;
@property(nonatomic,assign) int assetdebtrate;
@property(nonatomic,assign) int salesrevenue;
@property(nonatomic,assign) int pretaxprofit;
@property(nonatomic,assign) int aftertaxprofit;
@property(nonatomic,assign) int activitycashflow;
@property(nonatomic,retain) NSString* others;
@end
