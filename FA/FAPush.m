//
//  FAPush.m
//  benesse
//
//  Created by  on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FAPush.h"
#import "FAChatManager.h"
#import "FAUserData.h"
#import "FAInviteInfoData.h"
#define TAG_GRP 1
#define TAG_FRD 2

@implementation FAPush

@synthesize delegate;
@synthesize pushEnabled;
@synthesize alias;
@synthesize pushaps = aps;

@synthesize notificationTypes;

SINGLETON_IMPLEMENTATION(FAPush);
-(id)init {
    self = [super init];
    if(self) {
        autobadgeEnabled = YES;
        pushEnabled=YES;
    }
    return self;
}
- (void)dealloc
{
    
    [super dealloc];
}
+ (void)land{

}

- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types{
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
    notificationTypes = types;

}
/*- (void)registerDeviceToken:(NSData *)token{
    FACloud *cloud = [FACloud shared];
    NSString *deviceTokenString = [[[[token description]
                                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""]; 
    cloud.deviceToken = deviceTokenString;
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&devicetoken=%@",cloud.serverUrl.regdeviceurl,cloud.appId,cloud.appSecret,deviceTokenString];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        [cloud showValidateAlert:xmlStr];
        if ([xmlStr intValue]>10000) {
            cloud.userId = xmlStr;
        }
        //在registerDeviceTokenSucceeded方法中进行userId的本地保持
        [self notifyObservers:@selector(registerDeviceTokenSucceeded)];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        [self notifyObservers:@selector(registerDeviceTokenFailed:)
                   withObject:request];
        [request cancel];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    if (cloud.ready) {
        [request startAsynchronous];
    }
}
- (void)updateRegistration{
    [[FACloud shared] unRegisterDeviceToken];
}
*/

// Update (replace) token attributes
- (void)updateAlias:(NSString *)value userId:(NSString *)userId{
    FACloud *obj = [FACloud shared];
    if(obj.ready){
        NSString *urlStr = [NSString stringWithFormat:@"%@?id=%@&alias=%@",obj.serverUrl.chgaliasurl,userId,value];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setCompletionBlock:^{
            // Use when fetching text data
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *xmlStr = [request responseString];
            xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([xmlStr isEqualToString:@"0"]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重名错误"
                                                   message:@"请输入另一个不同的名字"
                                                  delegate:nil
                                         cancelButtonTitle:@"关闭"
                                         otherButtonTitles:nil];
                [alert show];
            }
            
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            
            [request cancel];
            NSLog(@"%@",[error localizedFailureReason]);
            //[indicatorView removeFromSuperview];
        }];
       
        [request startAsynchronous];
        
    }
}


- (void)enableAutobadge:(BOOL)enabled{
    autobadgeEnabled = enabled;
    //修改badge显示设置
    if (enabled) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:notificationTypes|UIRemoteNotificationTypeBadge];
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:notificationTypes&enabled];
    }
}
- (void)setBadgeNumber:(NSInteger)badgeNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}
- (void)resetBadge{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

//Handle incoming push notifications
- (void)handleNotification:(NSDictionary *)notification applicationState:(UIApplicationState)state{
    aps = [notification objectForKey:@"aps"];
    NSLog(@"aps = %@",aps);
    self.pushaps = aps;
    [self.pushaps retain];
    NSLog(@"ortoid=%@",[self.pushaps objectForKey:@"fromid"]);
    int kindInt = [[aps objectForKey:@"kind"] intValue];
    NSLog(@"kind =%d",kindInt);
    UIAlertView *alert;
    switch (kindInt) {
        case 1:
            if(state==UIApplicationStateActive) {
                 alert = [[UIAlertView alloc] initWithTitle:@"业务消息"
                                                                message:[aps objectForKey:@"alert"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:nil];
                [alert show];
            } 
            //[delegate saveSystemMessage:[aps objectForKey:@"alert"] formatid:[[aps objectForKey:@"formatid"] intValue] keyValue:[aps objectForKey:@"keyvalue"]];
            [self notifyObservers:@selector(saveSystemMessage:)
                       withObject:aps];
            break;
        case 2:
            
            //[delegate saveChatMessage:[aps objectForKey:@"alert"] freindId:[[aps objectForKey:@"id"] intValue] ];
            
            NSLog(@"alert=%@",[aps objectForKey:@"alert"]);
            NSLog(@"id=%@",[aps objectForKey:@"id"]);
            
            [self notifyObservers:@selector(saveChatMessage:)
                       withObject:aps];
            if(state==UIApplicationStateActive) {
                [[NSNotificationCenter defaultCenter] postNotificationName:FRIEND_MESSAGE_NOTIFICATION object:nil];
                //播放效果音乐
            }
            break;
        case 3:
            
            //[delegate saveGroupChatMessage:[aps objectForKey:@"alert"] gid:[[aps objectForKey:@"gid"] intValue] freindId:[[aps objectForKey:@"fromid"] intValue] ];
            [self notifyObservers:@selector(saveGroupChatMessage:)
                       withObject:aps];
            if(state==UIApplicationStateActive) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_MESSAGE_NOTIFICATION object:nil];
                //播放效果音乐
            }
            break;
        case 4:
            if(state==UIApplicationStateActive) {
                alert = [[UIAlertView alloc] init] ;
                alert.delegate = self;
                alert.title = @"群组邀请确认";
                alert.message = [aps objectForKey:@"alert"];
                [alert addButtonWithTitle:NSLocalizedString(@"nav_btn_qx", nil)];
                [alert addButtonWithTitle:@"同意"];
                alert.cancelButtonIndex = 0;
                alert.tag = TAG_GRP;
                [alert show];
            }else{
                [self notifyObservers:@selector(saveGroupInvite:)
                           withObject:aps];
            }
            //[delegate saveGroupInvite:[aps objectForKey:@"alert"] gid:[[aps objectForKey:@"gid"] intValue] groupname:[aps objectForKey:@"groupname"] freindId:[[aps objectForKey:@"fromid"] intValue]];
            
            break;
        case 5:
            if(state==UIApplicationStateActive) {
                alert = [[UIAlertView alloc] initWithTitle:@"群组成员增加"
                                                   message:[aps objectForKey:@"alert"]
                                                  delegate:nil
                                         cancelButtonTitle:@"关闭"
                                         otherButtonTitles:nil];
                [alert show];
            } 
            //[delegate addFreindToGroupId:[[aps objectForKey:@"gid"] intValue] freindname:[aps objectForKey:@"username"]  freindId:[[aps objectForKey:@"id"] intValue]];
            [self notifyObservers:@selector(addFreindToGroup:)
                       withObject:aps];
            break;
        case 6:
            if(state==UIApplicationStateActive) {
                alert = [[UIAlertView alloc] init] ;
                alert.delegate = self;
                alert.title = @"好友邀请确认";
                alert.message = [aps objectForKey:@"alert"];
                [alert addButtonWithTitle:NSLocalizedString(@"nav_btn_qx", nil)];
                [alert addButtonWithTitle:@"同意"];
                alert.cancelButtonIndex = 0;
                alert.tag = TAG_FRD;
                [alert show];
            }else{
                //[delegate saveFreindInvite:[aps objectForKey:@"alert"] freindname:[aps objectForKey:@"username"] freindId:[[aps objectForKey:@"fromid"] intValue]];
                [self notifyObservers:@selector(saveFreindInvite:)
                           withObject:aps];
            
            }
            break;
        case 7:
            if(state==UIApplicationStateActive) {
                alert = [[UIAlertView alloc] initWithTitle:@"增加好友"
                                                   message:[aps objectForKey:@"alert"]
                                                  delegate:nil
                                         cancelButtonTitle:@"关闭"
                                         otherButtonTitles:nil];
                [alert show];
            } 
            //[delegate addFreindToListId:[[aps objectForKey:@"fromid"] intValue] freindname:[aps objectForKey:@"username"]];
            [self notifyObservers:@selector(addFreindToList:)
                       withObject:aps];
            break;
        default:
            break;
    }
    
    
}

-(void)showInviteMessage{
    NSMutableArray* invites = [FAInviteInfoData search:-1];
    for (int i =0; i<[invites count]; i++) {
        FAInviteInfoData* inviteData = [invites objectAtIndex:i];
        UIAlertView *alert;
        if (inviteData.kind==4) {//群组邀请
            alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"群组邀请确认";
            alert.message = inviteData.alert;
            [alert addButtonWithTitle:NSLocalizedString(@"nav_btn_qx", nil)];
            [alert addButtonWithTitle:@"同意"];
            alert.cancelButtonIndex = 0;
            alert.tag = TAG_GRP;
            [alert show];
        }else if (inviteData.kind==6){//好友邀请
            alert = [[UIAlertView alloc] init];
            alert.delegate = self;
            alert.title = @"好友邀请确认";
            alert.message = inviteData.alert;
            [alert addButtonWithTitle:NSLocalizedString(@"nav_btn_qx", nil)];
            [alert addButtonWithTitle:@"同意"];
            alert.cancelButtonIndex = 0;
            alert.tag = TAG_FRD;
            [alert show];
        }
        inviteData.flg = 1;
        [inviteData saveRecord];
    }
}
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    FAChatManager *chatManager = [[FAChatManager alloc] init];
    FAUserData *user = [FAUserData search];
    if (alertView.tag == TAG_GRP){
        // 判断点击哪个按钮
        if ( buttonIndex != alertView.cancelButtonIndex ) {
            
            //[是]按钮被触摸后的处理 同意加入群组后，要发送确认
            [chatManager reponseToBeGroupMember:[[self.pushaps objectForKey:@"gid"] intValue] withId:user.no];
            [self notifyObservers:@selector(addGroupAndFriendToList:)
                       withObject:self.pushaps];
        } 
    }else if(alertView.tag == TAG_FRD){
        // 判断点击哪个按钮
        if ( buttonIndex != alertView.cancelButtonIndex ) {
            //[是]按钮被触摸后的处理，同意成为朋友后，要发送确认
            NSLog(@"id=%d",user.no);
            NSLog(@"toid=%@",[self.pushaps objectForKey:@"fromid"]);
            
            [chatManager reponseToBeFreind:[[self.pushaps objectForKey:@"fromid"] intValue] withId:user.no];
            [self notifyObservers:@selector(addFreindToList:)
                       withObject:self.pushaps];
        } 
    }
}

@end
