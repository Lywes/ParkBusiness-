//
//  PBFinanceAssureData.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBFinanceAssureData : NSObject
-(void)saveRecord;
+(PBFinanceAssureData*)searchData:(int)no;
+(void)deleteRecord:(int)recordId;
@property(nonatomic,assign) int no;
@property(nonatomic,retain) NSString* loanapply;
@property(nonatomic,assign) int applyproperty;
@property(nonatomic,retain) NSString* enterprise;
@property(nonatomic,assign) int creditamount;
@property(nonatomic,assign) int creditlimit;
@property(nonatomic,assign) int repaytype;
@property(nonatomic,retain) NSString* loanbankname;
@property(nonatomic,assign) int applycredituse;
@property(nonatomic,assign) int assurerate;
@end
