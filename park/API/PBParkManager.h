//
//  PBParkManager.h
//  ParkBusiness
//
//  Created by  on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXML.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@protocol PBParkManagerDelegate
@optional
- (void)refreshData;
- (void)sucessSendPostData:(NSObject*)Data;
@end

@interface PBParkManager : NSObject


@property (retain, readwrite) id<PBParkManagerDelegate> delegate;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, strong) NSMutableArray *itemNodes;
@property (nonatomic, assign) int keyValue;
- (void) getRequestData:(NSString *) urlString forValueAndKey:(NSDictionary *) valueAndKeyDictionary;
- (void) submitDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic;
- (NSString *)decodeFromPercentEscapeString:(NSString *)string;
-(void)xmlData:(NSString *)xmlStr;
@end
