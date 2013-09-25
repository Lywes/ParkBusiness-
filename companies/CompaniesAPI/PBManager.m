//
//  PBCompaniesManage.m
//  ParkBusiness
//
//  Created by QDS on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBManager.h"

@implementation PBManager
@synthesize request;
@synthesize parseData;
@synthesize delegate;
@synthesize acIndicator;

- (void) requestBackgroundXMLData:(NSString *) urlString forValueAndKey:(NSDictionary *) valueAndKeyDictionary
{
    if (parseData != nil) {
        [parseData removeAllObjects];
    }
    parseData = [[NSMutableArray alloc] init];
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(failedCompaniesXMLData)];
    [request setDidFinishSelector:@selector(finishCompaniesXMLData)];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    for (int i = 0; i < [valueAndKeyDictionary count]; i ++) {
        [request setPostValue:[valueAndKeyDictionary objectForKey:[[valueAndKeyDictionary allKeys] objectAtIndex:i]] forKey:[[valueAndKeyDictionary allKeys] objectAtIndex:i]];
    }
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
}


- (void) finishCompaniesXMLData
{
    //对网络请求数据进行操作，首先解码，然后将“,”替换为“ ”
    NSString *XMLString = [[self decodeFromPercentEscapeString:[request responseString]]stringByReplacingOccurrencesOfString:@"," withString:@" "];//将字符串前后的空格去掉 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    APDocument *doc = [APDocument documentWithXMLString:XMLString];
    APElement *rootElement = [doc rootElement];
    NSArray *rootElementChilds = [rootElement childElements];
    for (int i = 0; i < [rootElementChilds count]; i ++) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        if ([mutableDic count] != 0) {
            [mutableDic removeAllObjects];
        }
        for (APElement *element in [[rootElementChilds objectAtIndex:i] childElements]) {
            if (element.value == nil) {
                [mutableDic setValue:@"" forKey:element.name];
            } else {
                [mutableDic setValue:element.value forKey:element.name];
            }
        }
        [parseData addObject:mutableDic];
        [mutableDic release];
    }
    
    [delegate sucessParseXMLData];
    
}

//解码
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void) failedCompaniesXMLData
{
    [acIndicator stopAnimating];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
}

//警告
- (void) warningForSomeUnusual:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void) dealloc
{
    [acIndicator release];
    [super dealloc];
}

@end
