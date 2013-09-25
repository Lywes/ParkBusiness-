//
//  PBCompaniesManage.h
//  ParkBusiness
//
//  Created by QDS on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "PBActivityIndicatorView.h"
#import "APXML.h"

@protocol ParseDataDelegate <NSObject>
@optional
- (void) sucessParseXMLData;
@end

@interface PBManager : NSObject

@property (nonatomic, retain) PBActivityIndicatorView *acIndicator;
@property (nonatomic, retain) id<ParseDataDelegate> delegate;
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) NSMutableArray *parseData;

- (void) requestBackgroundXMLData:(NSString *) urlString forValueAndKey:(NSDictionary *) valueAndKeyDictionary;
@end
