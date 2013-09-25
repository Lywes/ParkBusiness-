//
//  PBSendData.h
//  ParkBusiness
//
//  Created by QDS on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@protocol SuccessSendMessage <NSObject>
@optional
- (void) successSendData;
@end


@interface PBSendData : NSObject
@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) id<SuccessSendMessage> delegate;
@property (nonatomic, retain) NSString *warnSting;
- (void) sendDataWithURL:(NSString *) urlString andValueAndKeyDic:(NSDictionary *) valueAndKeyDic;
@end
