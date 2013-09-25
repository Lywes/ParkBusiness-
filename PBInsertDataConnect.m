//
//  PBInsertDataConnect.m
//  ParkBusiness
//
//  Created by QDS on 13-4-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInsertDataConnect.h"
#import "FAGroupData.h"
@implementation PBInsertDataConnect
@synthesize delegate;
@synthesize XMLDataRequest;
@synthesize parseData;
@synthesize receiveStr;
@synthesize indicator;
@synthesize tableInfo;
- (void) getXMLDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic{
    //使用时确保parseData为空
    if (parseData != nil) {
        [parseData removeAllObjects];
    }
    parseData = [[NSMutableDictionary alloc] init];
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
    NSLog(@"%@",str);
    APDocument *doc = [APDocument documentWithXMLString:str];
    APElement *rootElement = [doc rootElement];
    NSArray *rootElementChilds = [rootElement childElements];
    
    for (int i=0;i<[rootElementChilds count];i++)
    {
        APElement *tablesElement = [rootElementChilds objectAtIndex:i];
        NSMutableArray *data = [[NSMutableArray alloc]init];
        for (APElement *tableElement in [tablesElement childElements])
        {
            NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
            if ([mutableDic count] != 0) {
                [mutableDic removeAllObjects];
            }
            for (APElement *childElement in [tableElement childElements])
            {
                if (childElement.value == nil) {
                    [mutableDic setValue:@"" forKey:childElement.name];
                } else {
                    [mutableDic setValue:[self decodeFromPercentEscapeString:childElement.value] forKey:childElement.name];
                }
            }
            [data addObject:mutableDic];
            [mutableDic release];
        }
        [parseData setObject:data forKey:[tableInfo objectAtIndex:i]];
    }
    
    [delegate sucessReceiveData:parseData withInfo:tableInfo];
    
}
- (void) getUpgradeDataFromUrl:(NSString *)str withDic:(NSMutableDictionary *)dic{
    //使用时确保parseData为空
    if (parseData != nil) {
        [parseData removeAllObjects];
    }
    parseData = [[NSMutableDictionary alloc] init];
    XMLDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [XMLDataRequest setValidatesSecureCertificate:NO];
    [XMLDataRequest setDelegate:self];
    //当成功获取数据，调用该sucessXMLData，当数据获取失败，调用failedXMLData
    [XMLDataRequest setDidFailSelector:@selector(failedXMLData)];
    [XMLDataRequest setDidFinishSelector:@selector(successGetUpgradeData)];
    [XMLDataRequest setRequestMethod:@"POST"];
    for (id key in dic) {
        NSString* value = [dic objectForKey:key];
        [XMLDataRequest setPostValue:value forKey:key];
    }
    [XMLDataRequest startAsynchronous];
    [XMLDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}
//成功获取XML数据后，开始解析数据，数据解析成功后，在特定的类中自定义协议中的方法
- (void) successGetUpgradeData
{
    NSString *str = [XMLDataRequest responseString];
    NSMutableDictionary* dataDic = [NSMutableDictionary new];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    APDocument *doc = [APDocument documentWithXMLString:str];
    APElement *rootElement = [doc rootElement];
    NSArray *rootElementChilds = [rootElement childElements];
    for (int i = 0; i < [rootElementChilds count]; i++)
    {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        NSMutableArray* mutableArr = [NSMutableArray new];
        for (APElement *childElement in [[rootElementChilds objectAtIndex:i] childElements])
        {
            if ([childElement childCount]>0) {
                NSMutableDictionary* subDic = [NSMutableDictionary new];
                for (APElement *subElement in [childElement childElements]) {
                    if (subElement.value == nil) {
                        [subDic setValue:@"" forKey:subElement.name];
                    } else {
                        [subDic setValue:[self decodeFromPercentEscapeString:subElement.value] forKey:subElement.name];
                    }
                    
                }
                [mutableArr addObject:subDic];
            }else{
                if (childElement.value == nil) {
                    [mutableDic setValue:@"" forKey:childElement.name];
                } else {
                    [mutableDic setValue:[self decodeFromPercentEscapeString:childElement.value] forKey:childElement.name];
                }
            }
            
        }
        APElement *child = [rootElementChilds objectAtIndex:i];
        if ([child.name isEqualToString:@"states"]) {
            [dataDic setObject:mutableDic forKey:child.name];
        }else{
            [dataDic setObject:mutableArr forKey:child.name];
        }
        
        [mutableDic release];
    }
    NSLog(@"xxxxxx%@",dataDic);
    [delegate successGetUpgradeData:dataDic];
}
- (void) getFriendDataFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic{
    //使用时确保parseData为空
    if (parseData != nil) {
        [parseData removeAllObjects];
    }
    parseData = [[NSMutableDictionary alloc] init];
    XMLDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [XMLDataRequest setValidatesSecureCertificate:NO];
    [XMLDataRequest setDelegate:self];
    //当成功获取数据，调用该sucessXMLData，当数据获取失败，调用failedXMLData
    [XMLDataRequest setDidFailSelector:@selector(failedXMLData)];
    [XMLDataRequest setDidFinishSelector:@selector(sucessPostdata)];
    [XMLDataRequest setRequestMethod:@"POST"];
    for (id key in dic) {
        NSString* value = [dic objectForKey:key];
        [XMLDataRequest setPostValue:value forKey:key];
    }
    [XMLDataRequest startAsynchronous];
    [XMLDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}
//成功获取XML数据后，开始解析数据，数据解析成功后，在特定的类中自定义协议中的方法
- (void) sucessPostdata
{
    NSError* error;
//    NSString* str = [XMLDataRequest responseString];
    NSData* requestData = [XMLDataRequest responseData];
    NSDictionary* loadDic = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableLeaves error:&error];
    for (id key in loadDic) {
        NSString *str = [[loadDic objectForKey:key] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([key isEqualToString:@"kbnmaster"]) {
            NSMutableArray* kbnArray = [self getArrayFromXMLDataWithString:str];
            PBKbnMasterModel *kbnmaster = [[PBKbnMasterModel alloc]init];
            [kbnmaster deleteRecord];//删除记录
            for (NSDictionary* dic in kbnArray) {
                if ([[dic objectForKey:@"name"] isEqualToString:@"rate"]&&![[dic objectForKey:@"id"] isEqualToString:@"5"]) {
                    kbnmaster.name = [self decodeFromPercentEscapeString:[dic objectForKey:@"name"]];
                }else{
                    kbnmaster.name = [dic objectForKey:@"name"];
                }
                kbnmaster.recordId = [[dic objectForKey:@"id"] intValue];
                kbnmaster.kind = [dic objectForKey:@"kind"];
                [kbnmaster saveRecord];
            }
        }
        if ([key isEqualToString:@"grouplist"]) {
            NSMutableArray* groupArray = [self getArrayFromXMLDataWithString:str];
            [FAGroupData deleteInstitudeData];
            //将金融机构追加至GROUPMASTER表
            for(NSMutableDictionary* dic in groupArray){
                FAGroupData* group = [[FAGroupData alloc]init];
                group.groupid = [[dic objectForKey:@"groupid"] intValue];
                group.flag = [[dic objectForKey:@"flag"] intValue];;
                group.imgpath = [dic objectForKey:@"imagepath"];
                group.groupname = [dic objectForKey:@"name"];
                group.createtime = [NSDate date];
                [group saveRecord];
            }
        }
        if ([key isEqualToString:@"userinfo"]) {
            NSMutableArray* userArray = [NSMutableArray arrayWithObjects:@"user",@"project",@"projectinfo",@"projectgroup",@"projectplan",@"projectcondition",@"investexperience",@"companyinfo",@"bankloaninfo",@"companybondinfo",@"financingassure",@"financinglease",@"patentinfo",@"financingleaseaccount",@"bankfinancingcase", nil];
           [self analyzeUserDataWithString:str withArr:userArray];
        }
        if ([key isEqualToString:@"load"]) {
            NSMutableArray* userArray = [NSMutableArray arrayWithObjects:@"friend",@"group", nil];
            [self analyzeUserDataWithString:str withArr:userArray];
        }
        
    }
    [delegate sucessLoadRegisterDataWithType:[loadDic count]==2?2:1];
    
    
}
//获取XML转化为Data数据
-(NSMutableArray*)getArrayFromXMLDataWithString:(NSString*)str{
    NSMutableArray* array = [NSMutableArray new];
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
        [array addObject:mutableDic];
        [mutableDic release];
    }
    return array;
}

//解析用户数据及朋友圈数据
-(void)analyzeUserDataWithString:(NSString*)str withArr:(NSMutableArray*)userArray{
    
    APDocument *doc = [APDocument documentWithXMLString:str];
    APElement *rootElement = [doc rootElement];
    NSArray *rootElementChilds = [rootElement childElements];
    
    for (int i=0;i<[rootElementChilds count];i++)
    {
        APElement *tablesElement = [rootElementChilds objectAtIndex:i];
        NSMutableArray *data = [[NSMutableArray alloc]init];
        for (APElement *tableElement in [tablesElement childElements])
        {
            NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
            if ([mutableDic count] != 0) {
                [mutableDic removeAllObjects];
            }
            for (APElement *childElement in [tableElement childElements])
            {
                if (childElement.value == nil) {
                    [mutableDic setValue:@"" forKey:childElement.name];
                } else {
                    [mutableDic setValue:[self decodeFromPercentEscapeString:childElement.value] forKey:childElement.name];
                }
            }
            [data addObject:mutableDic];
            [mutableDic release];
        }
        [parseData setObject:data forKey:[userArray objectAtIndex:i]];
    }
    if([userArray count]==2){
        [delegate sucessGetFriendData:parseData withInfo:userArray];
    }else{
        [delegate sucessReceiveData:parseData withInfo:userArray];
    }
}
//获取主页未读信息
- (void) getUnreadMessageFromUrl:(NSString *)str postValuesAndKeys:(NSMutableDictionary *)dic{
    //使用时确保parseData为空
    if (parseData != nil) {
        [parseData removeAllObjects];
    }
    parseData = [[NSMutableDictionary alloc] init];
    XMLDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [XMLDataRequest setValidatesSecureCertificate:NO];
    [XMLDataRequest setDelegate:self];
    //当成功获取数据，调用该sucessXMLData，当数据获取失败，调用failedXMLData
    [XMLDataRequest setDidFailSelector:@selector(failedXMLData)];
    [XMLDataRequest setDidFinishSelector:@selector(sucessGetUnreadMessage)];
    [XMLDataRequest setRequestMethod:@"POST"];
    for (id key in dic) {
        NSString* value = [dic objectForKey:key];
        [XMLDataRequest setPostValue:value forKey:key];
    }
    [XMLDataRequest startAsynchronous];
    [XMLDataRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}
//成功获取XML数据后
- (void) sucessGetUnreadMessage
{
    NSString *str = [XMLDataRequest responseString];
    NSLog(@"%@",str);
    NSMutableArray* allArray = [NSMutableArray new];
    APDocument *doc = [APDocument documentWithXMLString:str];
    APElement *rootElement = [doc rootElement];
    NSArray *rootElementChilds = [rootElement childElements];
    
    for (int i=0;i<[rootElementChilds count];i++)
    {
        NSMutableArray* superArr = [NSMutableArray new];
        APElement *childrenElement = [rootElementChilds objectAtIndex:i];
        for (APElement *childElement in [childrenElement childElements]) {
            if ([childElement childCount]>0) {
                NSMutableDictionary* dic = [NSMutableDictionary new];
                for (APElement*subElement in [childElement childElements]) {
                    [dic setObject:subElement.value forKey:subElement.name];
                }
                [superArr addObject:dic];
            }else{
                [superArr addObject:childElement.value];
            }
        }
        [allArray addObject:superArr];
        
    }
    
    [delegate sucessGetUnreadMessage:allArray];
    
}
//获取XML数据失败，给出提示信息
- (void) failedXMLData
{
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
    [self.indicator stopAnimating];
}

//警告
- (void) warning:(NSString *)str
{
    
}
//解码
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
