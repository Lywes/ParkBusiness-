//
//  FAFriendData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAFriendData : NSObject

+(NSMutableArray*)search:(int)friendid
           friendgroupid:(int)friendgroupid
                    name:(NSString*)name
                   limit:(int)limitNumber;
+(int)saveId:(int)no
   signature:(NSString*)signature
    friendid:(int)friendid
  friendname:(NSString*)friendname
     imgpath:(NSString*)imgpath
        icon:(UIImage*)icon
friendgroupid:(int)friendgroupid;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
+(BOOL)isFriend:(int)friendid;
+(FAFriendData *)getFriendDataById:(int)friendid;
+(void)updateRemark:(NSString*)remark withId:(int)friendid;
@property(nonatomic,readwrite)int no;
@property(nonatomic,retain,readwrite) NSString* signature;
@property(nonatomic,readwrite) int friendid;
@property(nonatomic,retain,readwrite) NSString* friendname;
@property(nonatomic,retain,readwrite) NSString* imgpath;
@property(nonatomic,retain,readwrite) NSString* remark;
@property(nonatomic,retain,readwrite) UIImage* icon;
@property(nonatomic,readwrite) int friendgroupid;

@end
