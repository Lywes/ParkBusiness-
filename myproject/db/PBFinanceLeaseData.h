//
//  PBFinanceLeaseData.h
//  ParkBusiness
//
//  Created by 上海 on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//


#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBFinanceLeaseData : NSObject
-(void)saveRecord;
+(PBFinanceLeaseData*)searchData:(int)no;
+(void)deleteRecord:(int)recordId;
@property(nonatomic,assign) int no;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int projectamount;
@property(nonatomic,assign) int receiptfund;
@property(nonatomic,retain) NSString* leasedeviceinfo;
@end
