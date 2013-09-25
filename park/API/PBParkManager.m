//
//  PBParkManager.m
//  ParkBusiness
//
//  Created by  on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkManager.h"
#import "APDocument.h"
#import "APXML.h"
@implementation PBParkManager

@synthesize delegate;
@synthesize itemNodes;
@synthesize request;
@synthesize keyValue;
//解码字符串
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//警告
-(void)warning:(NSString *)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

//请求数据
- (void) getRequestData:(NSString *) urlString forValueAndKey:(NSDictionary *) valueAndKeyDictionary
{
    if (itemNodes != nil) {
        [itemNodes removeAllObjects];
    }
    itemNodes = [[NSMutableArray alloc] init];
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(failedXMLData)];
    [request setDidFinishSelector:@selector(sucessXMLData)];
    [request setRequestMethod:@"POST"];
    
    for (int i = 0; i < [valueAndKeyDictionary count]; i ++) {
        [request setPostValue:[valueAndKeyDictionary objectForKey:[[valueAndKeyDictionary allKeys] objectAtIndex:i]] forKey:[[valueAndKeyDictionary allKeys] objectAtIndex:i]];
    }
    
    
    [request startAsynchronous];
}

//解析数据
-(void)sucessXMLData
{
    NSString *xmlRes = request.responseString;
//    xmlRes = [self decodeFromPercentEscapeString:xmlRes];
    
    APDocument *doc = [APDocument documentWithXMLString:xmlRes];
	APElement *rootElement = [doc rootElement];
	NSArray *childElements = [rootElement childElements];
	for (int i = 0;i < [childElements count];i++) {
		NSArray *allItems = [[childElements objectAtIndex:i] childElements];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init] ;
        if ([temDic count] > 0) {
            [temDic removeAllObjects];
        }
		for (APElement *child in allItems){
            [temDic setValue:(child.value==NULL)?@"":[self decodeFromPercentEscapeString:child.value] forKey:child.name];
            
        }
        [itemNodes addObject:temDic];
        
        [temDic release];
    }
    
    [delegate refreshData];
    
}

-(void)xmlData:(NSString *)xmlStr
{
    itemNodes = [[NSMutableArray alloc] init];
    if (itemNodes != nil) {
        [itemNodes removeAllObjects];
    }
    NSString *str = [self decodeFromPercentEscapeString:xmlStr];
    
    APDocument *doc = [APDocument documentWithXMLString:str];
    
	APElement *rootElement = [doc rootElement];
	NSArray *childElements = [rootElement childElements];
	for (int i = 0;i < [childElements count];i++) {
		NSArray *allItems = [[childElements objectAtIndex:i] childElements];
        NSMutableDictionary *temDic = [[NSMutableDictionary alloc]init] ;
        if ([temDic count] > 0) {
            [temDic removeAllObjects];
        }
		for (APElement *child in allItems){
            [temDic setValue:(child.value==NULL)?@"":child.value forKey:child.name];
            
        }
        [itemNodes addObject:temDic];
        
        [temDic release];
    }
    
    [delegate refreshData];
    
}

//提交数据到服务器
- (void) submitDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    //当成功获取数据，调用该sucessSendData，当数据获取失败，调用failedXMLData
    [request setDidFailSelector:@selector(failedSendData)];
    [request setDidFinishSelector:@selector(sucessSendData)];
    [request setRequestMethod:@"POST"];
    for (id key in dic) {
        NSString* value = [dic objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    [request startAsynchronous];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}
//成功获取XML数据后，开始解析数据，数据解析成功后，在特定的类中自定义协议中的方法
- (void) sucessSendData
{
    
    NSString *str = [request responseString];
    if (str==NULL||[str isEqualToString:@""]) {
    } else {
        self.keyValue = [str intValue];
        [delegate sucessSendPostData:self];
        
    }
}

//获取XML数据失败，给出提示信息
- (void)failedSendData
{

}

-(void)failedXMLData
{

}



@end
