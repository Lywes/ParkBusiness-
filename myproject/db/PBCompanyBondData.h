//
//  PBCompanyBondData.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBCompanyBondData : NSObject
-(void)saveRecord;
+(PBCompanyBondData*)searchData:(int)no;
+(void)deleteRecord:(int)recordId;
@property(nonatomic,assign) int no;
@property(nonatomic,assign) int bondtype;
@property(nonatomic,assign) int issueamount;
@property(nonatomic,assign) int bondamount;
@property(nonatomic,assign) int yearprofit;
@property(nonatomic,assign) int debttoequity;
@property(nonatomic,retain) NSString* others;
@end
