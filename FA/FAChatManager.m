//
//  FAChatManager.m
//  benesse
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FAChatManager.h"

@interface FAChatManager (Private)
-(void)showAddGroupValidateAlert:(NSString *)xmlStr WithName:(NSString *)name;
-(void)showSearchGroupByIdValidateAlert:(NSString *)xmlStr searchurl:(NSURL *)url ;
-(void)showSearchGroupByNameValidateAlert:(NSString *)xmlStr searchurl:(NSURL *)url; 
-(void)showQuitFromGroupValidateAlert:(NSString *)xmlStr;
@end
@implementation FAChatManager
@synthesize delegate;
@synthesize activity;
-(id)init{
    self = [super init];
    if (self) {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        activity = [[PBActivityIndicatorView alloc]initWithFrame:keywindow.bounds];
        [keywindow addSubview:activity];
    }
    return self;
}

-(void)sendMessageToFreind:(int)toid withGroupId:(int)gid fromId:(int)fromid withMessage:(NSString *)message{
    FACloud *cloud = [FACloud shared];
    NSString *urlStr = [NSString stringWithFormat:@"%@?toid=%d&fromid=%d&message=%@",cloud.serverUrl.singlemessageurl,toid,fromid,message];
    if (gid>0) {
        urlStr = [NSString stringWithFormat:@"%@&gid=%d",urlStr,gid];
    }
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![xmlStr isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据传送错误"
                                                            message:@"信息传送失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        
    }];
    [request startAsynchronous];
}
-(void)sendMessageTogroup:(int)gid fromId:(int)fromid withMessage:(NSString *)message{
    FACloud *cloud = [FACloud shared];
    NSString *urlStr = [NSString stringWithFormat:@"%@?gid=%d&fromid=%d&message=%@",cloud.serverUrl.groupmessageurl,gid,fromid,message];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![xmlStr isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据传送错误"
                                                            message:@"信息传送失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        
    }];
    [request startAsynchronous];
}
-(void)inviteToGroup:(int)gid toFreind:(int)fid fromid:(int)fromid{
    FACloud *cloud = [FACloud shared];
    NSString *urlStr = [NSString stringWithFormat:@"%@?toid=%d&gid=%d&fromid=%d",cloud.serverUrl.invitegroupurl,fid,gid,fromid];
    NSLog(@"invite to group =%@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![xmlStr isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据传送错误"
                                                            message:@"信息传送失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"群组邀请已经成功发出！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        
    }];
    [request startAsynchronous];
}
-(void)reponseToBeGroupMember:(int)gid withId:(int)userid{
    FACloud *cloud = [FACloud shared];
    NSString *urlStr = [NSString stringWithFormat:@"%@?id=%d&gid=%d",cloud.serverUrl.answergroupurl,userid,gid];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![xmlStr isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据传送错误"
                                                            message:@"信息传送失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        
    }];
    [request startAsynchronous];
}
-(void)inviteToBeFreindTo:(int)fid fromId:(int)fromid{
    [activity startAnimating];
    FACloud *cloud = [FACloud shared];
    NSString *urlStr = [NSString stringWithFormat:@"%@?toid=%d&fromid=%d",cloud.serverUrl.invitefreindurl,fid,fromid];
    NSLog(@"inviteurl = %@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [activity stopAnimating];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![xmlStr isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据传送错误"
                                                            message:@"信息传送失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统消息"
                                                            message:@"好友邀请信息成功发出！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }];
    [request setFailedBlock:^{
        [activity stopAnimating];
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        
    }];
    [request startAsynchronous];
}
-(void)reponseToBeFreind:(int)fid withId:(int)userid{
    FACloud *cloud = [FACloud shared];
    NSString *urlStr = [NSString stringWithFormat:@"%@?toid=%d&fromid=%d",cloud.serverUrl.answerfreindurl,fid,userid];
    NSLog(@"reponse url=%@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![xmlStr isEqualToString:@"1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据传送错误"
                                                            message:@"信息传送失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
            NSLog(@"成功发送同意回复");
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        
    }];
    [request startAsynchronous];
}
-(void)addNewGroupWithName:(NSString *)name byId:(int)userid{
    FACloud *cloud = [FACloud shared];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&name=%@&id=%d",cloud.serverUrl.addgroupurl,cloud.appId,cloud.appSecret,name,userid];
    NSLog(@"addgroup = %@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"add res = %@",xmlStr);
        [self showAddGroupValidateAlert:xmlStr WithName:name  ];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
}
-(void)searchGroupMemberByGroupId:(int)gid doById:(int)userid{
    FACloud *cloud = [FACloud shared];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&id=%d&gid=%d",cloud.serverUrl.searchfriendurl,cloud.appId,cloud.appSecret,userid,gid];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showSearchGroupByIdValidateAlert:xmlStr searchurl:url ];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
}
-(void)searchGroupMemberByName:(NSString *)name doById:(int)userid{
    FACloud *cloud = [FACloud shared];
    [activity startAnimating];
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&id=%d&name=%@",cloud.serverUrl.searchfriendurl,cloud.appId,cloud.appSecret,userid,name];
    //NSLog(@"findurl =%@",urlStr);
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [activity stopAnimating];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //NSLog(@"result = %@",xmlStr);
        [self showSearchGroupByNameValidateAlert:xmlStr searchurl:url ];
        
    }];
    [request setFailedBlock:^{
        [activity stopAnimating];
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据检索错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
}
-(void)quitFromGroup:(int)gid withUserid:(int)userid{
    FACloud *cloud = [FACloud shared];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&id=%d&gid=%d",cloud.serverUrl.quitgroupurl,cloud.appId,cloud.appSecret,userid,gid];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showQuitFromGroupValidateAlert:xmlStr  ];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据更新错误"
//                                                        message:@"无法连接服务器！"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"关闭"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
        PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
        [alert show];
        [alert release];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
}
-(void)showAddGroupValidateAlert:(NSString *)xmlStr WithName:(NSString *)name {
    UIAlertView *alert;
    NSString *errorMessage ;
    if ([xmlStr isEqualToString:@"duplicate"]) {
        errorMessage = @"组名重复追加失败！";
        alert = [[UIAlertView alloc] initWithTitle:@"群组追加错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"2"]){
        
        errorMessage = @"应用ID无效！";
        alert = [[UIAlertView alloc] initWithTitle:@"群组追加错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"3"]){
        errorMessage = @"发布ID无效，请确认是否完成付费！";
        alert = [[UIAlertView alloc] initWithTitle:@"群组追加错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"4"]){
        errorMessage = @"开发ID过期！";
        alert = [[UIAlertView alloc] initWithTitle:@"群组追加错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else{
        NSString *groupid = [xmlStr substringWithRange:NSMakeRange(7, [xmlStr length]-7)];
        [delegate saveGroup:name withGroupId:[groupid intValue]];
    }
    
    
}
-(void)showSearchGroupByIdValidateAlert:(NSString *)xmlStr searchurl:(NSURL *)url  {
    UIAlertView *alert;
    NSString *errorMessage ;
    if([xmlStr isEqualToString:@"2"]){
        
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
        [delegate getGroupMemberResult:res];
    }
}
-(void)showSearchGroupByNameValidateAlert:(NSString *)xmlStr searchurl:(NSURL *)url  {
    UIAlertView *alert;
    NSString *errorMessage ;
    if([xmlStr isEqualToString:@"2"]){
        
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
        //NSLog(@"res =%@",res);
        [delegate getGroupMemberResultByName:res];
    }
    
}
-(void)showQuitFromGroupValidateAlert:(NSString *)xmlStr  {
    UIAlertView *alert;
    NSString *errorMessage ;
    if([xmlStr isEqualToString:@"2"]){
        
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
        
    }
    
}
@end
