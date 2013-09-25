//
//  PBUnreadMessageData.h
//  ParkBusiness
//
//  Created by 上海 on 13-8-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"

@interface PBUnreadMessageData : NSObject
+(NSMutableArray*)searchMessageWithKind:(NSString*)kinds;
+(int)countOfUnreadMessageWithKind:(NSString*)kinds;
+(int)updateOldNumWithKind:(NSString*)kind;
+(int)updateNewNumWithKind:(NSString*)kind withNewNum:(int)newnum;
+(int)updateMessageData:(NSMutableDictionary*)messageDic;
+(int)saveMyNeedsWithDic:(NSMutableDictionary*)dic;
+(int)updateNeedsMessageData:(NSMutableArray*)messageArr;
//更新需求未读信息数
+(int)updateOldNumWithNeedsNo:(int)needsno withType:(int)type;
//检索需求未读信息数目
+(int)countOfUnreadNeedsMessageWithType:(int)type WithNeedsNo:(int)needsno;
//更新需求信息
+(void)updateMyNeedsWithArray:(NSMutableArray*)array withType:(int)type;
@property(nonatomic,assign)int oldnum;
@property(nonatomic,assign)int newnum;
@property(nonatomic,assign)int needsno;
@property(nonatomic,retain,readwrite) NSString* kind;
@end
