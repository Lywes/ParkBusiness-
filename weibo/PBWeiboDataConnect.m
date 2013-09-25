//
//  PBWeiboDataConnect.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWeiboDataConnect.h"

@implementation PBWeiboDataConnect

@synthesize delegate = _delegate;
@synthesize XMLDataRequest;
@synthesize parseData;
@synthesize receiveStr;
@synthesize indicator;

- (void) getXMLDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic{
    //使用时确保parseData为空
    if (parseData != nil) {
        [parseData removeAllObjects];
    }
    parseData = [[NSMutableArray alloc] init];
    XMLDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [XMLDataRequest setValidatesSecureCertificate:NO];
    [XMLDataRequest setDelegate:self];
    //当成功获取数据，调用该sucessXMLData，当数据获取失败，调用failedXMLData
    [XMLDataRequest setDidFailSelector:@selector(failedXMLData)];
    [XMLDataRequest setDidFinishSelector:@selector(sucessXMLData)];
    [XMLDataRequest setRequestMethod:@"POST"];
    for (id key in dic) {
        NSString* value = [dic objectForKey:key];
        [XMLDataRequest setPostValue:value forKey:key];
    }
    [XMLDataRequest startAsynchronous];
    [XMLDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];

}
//成功获取XML数据后，开始解析数据，数据解析成功后，在特定的类中自定义协议中的方法
- (void) sucessXMLData
{
    NSString *str = [XMLDataRequest responseString];
    NSLog(@"sucessXMLData= %@",str);
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    APDocument *doc = [APDocument documentWithXMLString:str];
    APElement *rootElement = [doc rootElement];
    NSArray *rootElementChilds = [rootElement childElements];

    for (int i = 0; i < [rootElementChilds count]; i++)
    {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        if ([mutableDic count] != 0) {
            [mutableDic removeAllObjects];
        }
        for (APElement *childElement in [[rootElementChilds objectAtIndex:i] childElements])
        {
            if (childElement.value == nil) {
                [mutableDic setValue:@"" forKey:childElement.name];
            } else {
                [mutableDic setValue:[self decodeFromPercentEscapeString:childElement.value] forKey:childElement.name];
            }
        }
        [parseData addObject:mutableDic];
        [mutableDic release];
    }
    
    [_delegate sucessParseXMLData:self];

}

//获取XML数据失败，给出提示信息
- (void) failedXMLData
{
    [self.indicator stopAnimating];
    NSLog(@"error=%@",[XMLDataRequest error]);
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
}
//提交数据到服务器
- (void) submitDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic{
    XMLDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [XMLDataRequest setValidatesSecureCertificate:NO];
    [XMLDataRequest setDelegate:self];
    //当成功获取数据，调用该sucessSendData，当数据获取失败，调用failedXMLData
    [XMLDataRequest setDidFailSelector:@selector(failedSendData)];
    [XMLDataRequest setDidFinishSelector:@selector(sucessSendData)];
    [XMLDataRequest setRequestMethod:@"POST"];
    for (id key in dic) {
        id value = [dic objectForKey:key];
        [XMLDataRequest setPostValue:value forKey:key];
    }
    [XMLDataRequest startAsynchronous];
    [XMLDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}

- (void) sucessSendData
{
    NSString *str = [XMLDataRequest responseString];
    NSLog(@"%@",str);
    if (str==NULL||[str isEqualToString:@""]) {
        
    } else {
        receiveStr = str;
        [_delegate sucessSendPostData:self];
    }
}


- (void) failedSendData
{
    [self.indicator stopAnimating];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
    if ([_delegate respondsToSelector:@selector(requestFilad:)]) {
        [_delegate requestFilad:self];
    }
}
//警告
- (void) warning:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
    [alert release];
}
//解码
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
