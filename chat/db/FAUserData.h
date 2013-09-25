//
//  FAUserData.h
//  PDFReader
//
//  Created by wangzhigang on 12-10-16.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface FAUserData : NSObject

+(FAUserData*)search;
+(int)saveId:(int)no
      pushid:(NSString*)pushid
        name:(NSString*)name
   signature:(NSString*)signature
        icon:(UIImage*)icon
      parkno:(int)parkno;
-(void)saveRecord;
-(void)deleteRecord;
+(void)deleteId:(int)recordId;
@property(nonatomic,readwrite)int no;
@property(nonatomic,readwrite)int parkno;
@property(nonatomic,retain,readwrite) NSString* pushid;
@property(nonatomic,retain,readwrite) NSString* name;
@property(nonatomic,retain,readwrite) NSString* signature;
@property(nonatomic,retain,readwrite) UIImage* icon;

@end
