//
//  PBCompanyDataManager.h
//  ParkBusiness
//
//  Created by QDS on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DBPATH @"data.db"
@interface PBCompanyDataManager : NSObject
+ (NSMutableArray *) getMyFriendListFromSQL;
@end
