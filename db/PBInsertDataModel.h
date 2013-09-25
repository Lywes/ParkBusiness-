//
//  PBInsertDataModel.h
//  ParkBusiness
//
//  Created by QDS on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define DBPATH @"data.db"
@interface PBInsertDataModel : NSObject

+(int)saveUserRecords:(NSDictionary*)dic;
+(int)saveProjectRecord:(NSMutableDictionary*)dic;
+(int)saveProjectInfoRecord:(NSMutableDictionary*)dic;
+(int)saveProjectGroupRecord:(NSMutableDictionary*)dic;
+(int)saveProjectPlanRecord:(NSMutableDictionary*)dic;
+(int)saveProjectConditionRecord:(NSMutableDictionary*)dic;
+(int)saveInvestExperienceRecord:(NSMutableDictionary*)dic;
+(int)saveFriendRecord:(NSMutableDictionary*)dic;
+(int)saveGroupRecord:(NSMutableDictionary*)dic;
+(int)saveCompanyInfoRecord:(NSMutableDictionary*)dic;
+(int)saveBankLoanRecord:(NSMutableDictionary *)dic;
+(int)saveCompanyBondRecord:(NSMutableDictionary *)dic;
+(int)saveFinancingAssureRecord:(NSMutableDictionary *)dic;
+(int)saveFinancingLeaseRecord:(NSMutableDictionary *)dic;
+(int)savePatentInfoRecord:(NSMutableDictionary *)dic;
+(int)saveFinancingAccountRecord:(NSMutableDictionary *)dic;
+(int)saveBankFinancingCaseRecord:(NSMutableDictionary *)dic;
@end