//
//  PBBankLoanData.h
//  ParkBusiness
//
//  Created by QDS on 13-5-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBBankLoanData : NSObject
-(void)saveRecord;
+(PBBankLoanData*)searchData:(int)projectno;
@property(nonatomic,assign) int no;
@property(nonatomic,assign) int projectno;
@property(nonatomic,assign) int securedform;
@property(nonatomic,assign) int applyloan;
@property(nonatomic,assign) int loanlimit;
@property(nonatomic,assign) int yearraterange;
@property(nonatomic,assign) int loanuse;
@property(nonatomic,retain) NSString *others;
@end
