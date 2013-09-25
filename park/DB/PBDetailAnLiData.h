//
//  PBDetailAnLiData.h
//  ParkBusiness
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBDetailAnLiData : NSObject
+(NSMutableArray *)search;
+(int)SaveId:(int)no 
        name:(NSString *)name 
        trade:(NSString *)trade 
        projectintroduce:(NSString *)projectintroduce
        projectstage:(NSString *)projectstage
        starttime:(NSString *)starttime
        money:(int)money
        moneyunit:(int)moneyunit
        ycno:(int)ycno
projectinfono:(int)projectinfono;

@property (nonatomic,assign) int no;
@property (nonatomic,retain,readwrite) NSString *name;
@property (nonatomic,retain,readwrite) NSString *trade;
@property (nonatomic,retain,readwrite) NSString *projectintroduce;
@property (nonatomic,retain,readwrite) NSString *projectstage;
@property (nonatomic,retain,readwrite) NSString *starttime;
@property (nonatomic,assign) int money;
@property (nonatomic,assign) int moneyunit;
@property (nonatomic,assign) int ycno;
@property (nonatomic,assign) int projectinfono;

@end
