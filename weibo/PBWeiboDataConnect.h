//
//  PBWeiboDataConnect.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXML.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PBActivityIndicatorView.h"
@class PBWeiboDataConnect;
@protocol PBWeiboDataDelegate <NSObject>
@optional
- (void) sucessParseXMLData:(PBWeiboDataConnect*)weiboDatas;
- (void) sucessSendPostData:(PBWeiboDataConnect*)weiboDatas;
-(void)requestFilad:(PBWeiboDataConnect*)weiboDatas;;
@end
@interface PBWeiboDataConnect : NSObject{
    id _delegate;
}

@property (nonatomic, retain) ASIFormDataRequest *XMLDataRequest;
@property (nonatomic, retain) NSMutableArray *parseData;
@property (nonatomic, retain) NSString *receiveStr;
@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) id<PBWeiboDataDelegate> delegate;
- (void) getXMLDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic;
- (void) submitDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic;
- (NSString *)decodeFromPercentEscapeString:(NSString *)string;
@end


