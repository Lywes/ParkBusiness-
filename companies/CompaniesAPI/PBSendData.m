//
//  PBSendData.m
//  ParkBusiness
//
//  Created by QDS on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSendData.h"

@implementation PBSendData
@synthesize warnSting;
@synthesize delegate;
@synthesize request;


- (void) sendDataWithURL:(NSString *) urlString andValueAndKeyDic:(NSDictionary *) valueAndKeyDic
{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(sendFailed)];
    [request setDidFinishSelector:@selector(sendSucceed)];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    NSArray *keysArray = [valueAndKeyDic allKeys];
    for (int i = 0; i < [valueAndKeyDic count]; i ++) {
        [request setPostValue:[valueAndKeyDic objectForKey:[keysArray objectAtIndex:i]] forKey:[keysArray objectAtIndex:i]];
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
}

- (void) sendFailed
{
    warnSting = @"failed";
    [delegate successSendData];
}

- (void)sendSucceed
{
    NSString *XMLString =[request responseString];
    if ([XMLString intValue]>0) {
        warnSting = @"succeed";
    } else {
        warnSting = @"failed";
    }
    [delegate successSendData];
}
@end
