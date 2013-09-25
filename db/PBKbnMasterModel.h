//
//  PBKbnMasterData.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBKbnMasterModel : NSObject

+(NSString*)getKbnNameById:(int)recordId withKind:(NSString*)kind;
-(void)saveRecord;
-(void)deleteRecord;
+(NSMutableArray*)getKbnInfoByKind:(NSString*)kind;
+(int)getKbnIdByName:(NSString*)name withKind:(NSString*)kind;
@property(nonatomic,retain,readwrite) NSString* kind;
@property(nonatomic,readwrite) int recordId;
@property(nonatomic,retain,readwrite)NSString* name;
@end
