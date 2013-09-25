//
//  DBAccess.m
//  PDFReader
//
//  Created by wangzhigang on 12-10-15.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "DBAccess.h"
#import <sqlite3.h>
#define DBPATH @"data.db"
#define DBFLAG @"dbflag"
//static sqlite3 *database = nil;
@implementation DBAccess
-(void)copyDatabaseIfNeeded
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* flagPath = [documentsDir stringByAppendingPathComponent:DBFLAG];
  // NSLog(flagPath);
    BOOL success = [fileManager fileExistsAtPath:flagPath];
    if (!success) {
        NSString* dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
        NSString* templateDBPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"template.sqlite"];
        if ([fileManager fileExistsAtPath:dbPath] == YES) {
            [fileManager removeItemAtPath:dbPath error:NULL];
        }else{
            success = [fileManager copyItemAtPath:templateDBPath toPath:dbPath error:&error];
            if (!success) {
                NSAssert1(0, @"Failed to create database :%@", [error localizedDescription]);
                return;
            }
            [fileManager createFileAtPath:flagPath contents:nil attributes:nil];
        }
    }
}
@end
