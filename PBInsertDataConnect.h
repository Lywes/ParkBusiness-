//
//  PBInsertDataConnect.h
//  ParkBusiness
//
//  Created by QDS on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXML.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PBActivityIndicatorView.h"
@class PBInsertDataConnect;
@protocol PBInsertDataDelegate <NSObject>
@optional
-(void)sucessLoadRegisterDataWithType:(int)type;
-(void)sucessReceiveData:(NSMutableDictionary*)parseData withInfo:(NSMutableArray*)tableInfo;
-(void)sucessGetFriendData:(NSMutableDictionary*)parseData withInfo:(NSMutableArray*)tableInfo;
-(void)successGetUpgradeData:(NSMutableDictionary*)insertData;
-(void)sucessGetUnreadMessage:(NSMutableArray*)messageArr;
@end
@interface PBInsertDataConnect : NSObject
@property (nonatomic, retain) ASIFormDataRequest *XMLDataRequest;
@property (nonatomic, retain) NSMutableDictionary *parseData;
@property (nonatomic, retain) NSMutableArray *tableInfo;
@property (nonatomic, retain) NSString *receiveStr;
@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) id<PBInsertDataDelegate> delegate;
- (void) getUnreadMessageFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic;
- (void) getUpgradeDataFromUrl:(NSString *)str withDic:(NSMutableDictionary *)dic;
- (void) getXMLDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic;
- (void) getFriendDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic;
- (NSString *)decodeFromPercentEscapeString:(NSString *)string;
@end
