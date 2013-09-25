//
//  PBCompanyData.h
//  ParkBusiness
//
//  Created by QDS on 13-5-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBCompanyData : NSObject
-(int)saveRecord;
+(PBCompanyData*)searchImageData:(int)userid;
+(PBCompanyData*)searchData:(int)userid;
-(NSMutableDictionary*)postDataToServer:(NSString*)mode;
@property(nonatomic,assign) int no;
@property(nonatomic,assign) int parkno;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain,readwrite) UIImage* image;
@property(nonatomic,retain) NSString *taxregistry;
@property(nonatomic,retain) NSString *organizingcode;
@property(nonatomic,retain) NSString *representative;
@property(nonatomic,retain) NSString *bank;
@property(nonatomic,retain) NSString *companyaccount;
@property(nonatomic,retain) NSString *accountname;
@property(nonatomic,retain) NSString *telephone;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,assign) int staffnum;
@property(nonatomic,assign) int yearsale;
@property(nonatomic,assign) int fixedassets;
@property(nonatomic,assign) int yearprofit;
@property(nonatomic,assign) int totaldebt;
@property(nonatomic,assign) int registerfund;
@property(nonatomic,assign) int receiptfund;
@property(nonatomic,retain) NSString *mainproducts;
@property(nonatomic,retain) NSString *tradeinfo;
@property(nonatomic,retain) NSString *customerinfo;
@property(nonatomic,assign) int actualoperatesite;
@property(nonatomic,retain) NSDate *leasedate;
@property(nonatomic,assign) int averagerent;
@property(nonatomic,assign) int isfranchise;
@property(nonatomic,assign) int havefranchise;
@end
