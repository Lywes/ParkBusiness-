//
//  FADataManager.m
//  benesse
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FADataManager.h"


@interface FADataManager (Private)


-(void)showWriteValidateAlert:(NSString *)xmlStr sendData:(NSDictionary *)data;
-(void)showSearchValidateAlert:(NSString *)xmlStr searchurl:(NSURL *)url withFormatId:(int)formatid;
@end

@implementation FADataManager
@synthesize delegate;

- (void)writeWithFormatId:(int)fid sendData:(NSDictionary *)data 
{
    FACloud *cloud = [FACloud shared];
    NSArray *keys = [data allKeys];
    NSString *value;
    NSString *param =@"";
    for (int i=0; i<[keys count]; i++) {
        value = (NSString*)[data objectForKey:[keys objectAtIndex:i]]; 
        param = [NSString stringWithFormat:@"%@&%@=%@",param,[keys objectAtIndex:i],value];
    }
    //NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&devicetoken=%@&formatid=%d%@",cloud.serverUrl.writeurl,cloud.appId,cloud.appSecret,cloud.deviceToken,fid,param];
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&devicetoken=%@&formatid=%d%@",@"http://www.5asys.com/write",cloud.appId,cloud.appSecret,cloud.deviceToken,fid,param];
    NSLog(@"write 5asys url = %@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showWriteValidateAlert:xmlStr sendData:data ];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
                                           message:@"无法连接服务器！"
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
}
-(void)showWriteValidateAlert:(NSString *)xmlStr sendData:(NSDictionary *)data{
    UIAlertView *alert;
    NSString *errorMessage ;
    if ([xmlStr isEqualToString:@"101"]) {
        errorMessage = @"数据更新开关没有开启！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"2"]){
        
        errorMessage = @"应用ID无效！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"3"]){
        errorMessage = @"发布ID无效，请确认是否完成付费！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"4"]){
        errorMessage = @"开发ID过期！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        NSString *key = [xmlStr substringWithRange:NSMakeRange(3, [xmlStr length]-3)];
        [delegate saveData:data primaryKey:key];
    }
    
}
- (void)searchDataWithFormatId:(int)fid condition:(NSDictionary *)data;
{
    FACloud *cloud = [FACloud shared];
    NSArray *keys = [data allKeys];
    NSString *value;
    NSString *param =@"";
    for (int i=0; i<[keys count]; i++) {
        value = (NSString*)[data objectForKey:[keys objectAtIndex:i]]; 
        param = [NSString stringWithFormat:@"%@&%@=%@",param,[keys objectAtIndex:i],value];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&formatid=%d%@",cloud.serverUrl.searchinfourl,cloud.appId,cloud.appSecret,fid,param];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showSearchValidateAlert:xmlStr searchurl:url withFormatId:fid];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
                                                        message:@"无法连接服务器！"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
}
-(void)showSearchValidateAlert:(NSString *)xmlStr searchurl:(NSURL *)url withFormatId:(int)formatid {
    UIAlertView *alert;
    NSString *errorMessage ;
    if ([xmlStr isEqualToString:@"101"]) {
        errorMessage = @"数据检索开关没有开启！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"2"]){
        
        errorMessage = @"应用ID无效！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"3"]){
        errorMessage = @"发布ID无效，请确认是否完成付费！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"4"]){
        errorMessage = @"开发ID过期！";
        alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        NSArray *res = [[[NSArray alloc] initWithContentsOfURL:url]autorelease];
        [delegate searchResult:res withFormatId:formatid];
    }
    
}
@end
