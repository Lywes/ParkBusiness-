/*
 
 */
#import "FACloud.h"


NSString* const FACloudTakeOffOptionsCloudConfigKey = @"CloudConfigKey";
NSString* const FACloudTakeOffOptionsLaunchOptionsKey = @"LaunchOptionsKey";
NSString* const FACloudTakeOffOptionsDefaultUsernameKey = @"DefaultUsernameKey";
NSString* const FACloudTakeOffOptionsDefaultPasswordKey = @"DefaultPasswordKey";
BOOL logging=YES;
@interface FACloud (Private)

-(void)getServerURL;
-(void)showValidateAlert:(NSString *)xmlStr;
@end

@implementation FACloud

@synthesize deviceToken=deviceToken_;
@synthesize userId;
@synthesize server;
@synthesize appId;
@synthesize parkno;
@synthesize appSecret;
@synthesize deviceTokenHasChanged;
@synthesize ready;
@synthesize serverUrl;

SINGLETON_IMPLEMENTATION(FACloud);
-(id)init {
    self = [super init];
    if(self) {
        //初始化验证标志ready
        ready = NO;
    }
    return self;
}
+ (void)takeOff:(NSDictionary *)options
{
    
    //NSDictionary *launchOptions = [options objectForKey:FACloudTakeOffOptionsLaunchOptionsKey];
    
    NSDictionary *cloudConfigOptions = [options objectForKey:FACloudTakeOffOptionsCloudConfigKey];
    
    BOOL debugFlag = NO;
    if ([[cloudConfigOptions objectForKey:@"APP_STORE_OR_AD_HOC_BUILD"] isEqualToString:@"YES"]) {
        debugFlag = YES;
    }
    FACloud *facloud = [FACloud shared];
    
    facloud.ready = NO;
    if (debugFlag) {
        facloud.parkno = (NSString *)[cloudConfigOptions objectForKey:@"PRODUCTION_APP_PARKNO"];
        facloud.appId = (NSString *)[cloudConfigOptions objectForKey:@"PRODUCTION_APP_KEY"];
        facloud.appSecret = (NSString *)[cloudConfigOptions objectForKey:@"PRODUCTION_APP_SECRET"];
    }else{
        facloud.parkno = (NSString *)[cloudConfigOptions objectForKey:@"PRODUCTION_APP_PARKNO"];
        facloud.appId = (NSString *)[cloudConfigOptions objectForKey:@"DEVELOPMENT_APP_KEY"];
        facloud.appSecret = (NSString *)[cloudConfigOptions objectForKey:@"DEVELOPMENT_APP_SECRET"];
    }
    
    [facloud getServerURL];
    [facloud validateAppKey];
    

}

+ (void)land{

}

-(void)getServerURL {
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
//        NSArray *_list = [[[NSArray alloc] initWithContentsOfFile:@"setting.plist"]autorelease];
//        //if(![self checkServerAndInternet]||!_list) {
//
//        if(_list) {
//            serverUrl=nil;
//            serverUrl=[[FAServerURL alloc] init];
//            
//            // now creating all issues and storing in the storeIssues array
//            
//            NSDictionary *urlDict = (NSDictionary *)[_list objectAtIndex:0];
//            serverUrl.regdeviceurl = [urlDict objectForKey:@"regdeviceurl"];
//            serverUrl.chgaliasurl = [urlDict objectForKey:@"chgaliasurl"];
//            serverUrl.writeurl = [urlDict objectForKey:@"writeurl"];
//            serverUrl.searchinfourl = [urlDict objectForKey:@"searchinfourl"];
//            serverUrl.validateurl = [urlDict objectForKey:@"validateurl"];
//            serverUrl.singlemessageurl = [urlDict objectForKey:@"singlemessageurl"];
//            serverUrl.groupmessageurl = [urlDict objectForKey:@"groupmessageurl"];
//            serverUrl.invitegroupurl = [urlDict objectForKey:@"invitegroupurl"];
//            serverUrl.answergroupurl = [urlDict objectForKey:@"answergroupurl"];
//            serverUrl.invitefreindurl = [urlDict objectForKey:@"invitefreindurl"];
//            serverUrl.answerfreindurl = [urlDict objectForKey:@"answerfreindurl"];
//            serverUrl.addgroupurl = [urlDict objectForKey:@"addgroupurl"];
//            serverUrl.searchfriendurl = [urlDict objectForKey:@"searchfriendurl"];
//            serverUrl.quitgroupurl = [urlDict objectForKey:@"quitgroupurl"];
//            //开始验证应用ID
//            if (!serverUrl.validateurl) {
//                [self validateAppKey];
//            }
//            
//        } else {
//            FA_BLog(@"Server URL setting file download failed.");
//            wifiAlert = [[UIAlertView alloc] initWithTitle:@"网络连接错误"
//                                               message:@"请检查使用设备的网络设置！"
//                                              delegate:self
//                                     cancelButtonTitle:@"关闭"
//                                     otherButtonTitles:@"设置",nil];
//            [wifiAlert show];
//            
//        }
//    });
    NSString* setting = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"setting.plist"];
    NSArray *_list = [[[NSArray alloc] initWithContentsOfFile:setting]autorelease];
    //if(![self checkServerAndInternet]||!_list) {
    
    if(_list) {
        serverUrl=nil;
        serverUrl=[[FAServerURL alloc] init];
        
        // now creating all issues and storing in the storeIssues array
        
        NSDictionary *urlDict = (NSDictionary *)[_list objectAtIndex:0];
        serverUrl.regdeviceurl = [urlDict objectForKey:@"regdeviceurl"];
        serverUrl.chgaliasurl = [urlDict objectForKey:@"chgaliasurl"];
        serverUrl.writeurl = [urlDict objectForKey:@"writeurl"];
        serverUrl.searchinfourl = [urlDict objectForKey:@"searchinfourl"];
        serverUrl.validateurl = [urlDict objectForKey:@"validateurl"];
        serverUrl.singlemessageurl = [urlDict objectForKey:@"singlemessageurl"];
        serverUrl.groupmessageurl = [urlDict objectForKey:@"groupmessageurl"];
        serverUrl.invitegroupurl = [urlDict objectForKey:@"invitegroupurl"];
        serverUrl.answergroupurl = [urlDict objectForKey:@"answergroupurl"];
        serverUrl.invitefreindurl = [urlDict objectForKey:@"invitefreindurl"];
        serverUrl.answerfreindurl = [urlDict objectForKey:@"answerfreindurl"];
        serverUrl.addgroupurl = [urlDict objectForKey:@"addgroupurl"];
        serverUrl.searchfriendurl = [urlDict objectForKey:@"searchfriendurl"];
        serverUrl.quitgroupurl = [urlDict objectForKey:@"quitgroupurl"];
        //开始验证应用ID
        if (!serverUrl.validateurl) {
            [self validateAppKey];
        }
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==wifiAlert) {
        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(void)validateAppKey{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&parkno=%@",@"http://www.5asys.com/validate",self.appId,self.appSecret,self.parkno];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([xmlStr isEqualToString:@"1"]||[xmlStr isEqualToString:@"11"]) {
            ready = YES;
        }
        [self showValidateAlert:xmlStr];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
        NSLog(@"%@",[error localizedFailureReason]);
        //[indicatorView removeFromSuperview];
    }];
    [request startAsynchronous];
    
}
-(void)showValidateAlert:(NSString *)xmlStr{
    UIAlertView *alert;
    NSString *errorMessage = @"服务器系统错误";
    if ([xmlStr isEqualToString:@"0"]) {
        errorMessage = @"应用ID及验证码没有设置！";
        alert = [[UIAlertView alloc] initWithTitle:@"验证错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"2"]){
        
        errorMessage = @"应用ID无效！";
        alert = [[UIAlertView alloc] initWithTitle:@"验证错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"3"]){
        errorMessage = @"发布ID无效，请确认是否完成付费！";
        alert = [[UIAlertView alloc] initWithTitle:@"验证错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if([xmlStr isEqualToString:@"4"]){
        errorMessage = @"开发ID过期！";
        alert = [[UIAlertView alloc] initWithTitle:@"验证错误"
                                           message:errorMessage
                                          delegate:nil
                                 cancelButtonTitle:@"关闭"
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

/**
 * Register a device token with UA. This will register a device token without an alias or tags.
 * If an alias is set on the device token, it will be removed. Tags will not be changed.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 *
 * @param token The device token to register.
 */
- (void)registerDeviceToken:(NSData *)token{
    NSString *deviceTokenString = [[[[token description]
                                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""]; 
    self.deviceToken = deviceTokenString;
    //NSLog(@"deviceToken=%@" ,self.deviceToken);
    NSString *urlStr = [NSString stringWithFormat:@"%@?appkey=%@&appsecret=%@&devicetoken=%@&parkno=%@",@"http://www.5asys.com/regdevice",self.appId,self.appSecret,deviceTokenString,parkno];
    NSLog(@"register url = %@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        // Use when fetching text data
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *xmlStr = [request responseString];
        //NSLog(@"res = %@",xmlStr);
        xmlStr = [xmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self showValidateAlert:xmlStr];
        if ([xmlStr intValue]>10000) {
            userId = xmlStr;
            NSLog(@"userId = %@",userId);
            [self notifyObservers:@selector(registerDeviceTokenSucceededAndSaveUserId:)
                       withObject:userId];
        }
        
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        
        [request cancel];
        NSLog(@"%@",[error localizedFailureReason]);
        [self notifyObservers:@selector(registerDeviceTokenFailedAndShowFailureReason:)
                   withObject:[error localizedFailureReason]];
        //[indicatorView removeFromSuperview];
    }];
    
    [request startAsynchronous];
    
    
}

/**
 * Register the current device token with UA.
 *
 * @param info An NSDictionary containing registraton keys and values. See
 * http://urbanairship.com/docs/push.html#registration for details.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 */
- (void)registerDeviceTokenWithExtraInfo:(NSDictionary *)info{

}

/**
 * Register a device token and alias with UA.  An alias should only have a small
 * number (< 10) of device tokens associated with it. Use the tags API for arbitrary
 * groupings.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 *
 * @param token The device token to register.
 * @param alias The alias to register for this device token.
 */
- (void)registerDeviceToken:(NSData *)token withAlias:(NSString *)alias{

}

/**
 * Register a device token with a custom API payload.
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 *
 * @param token The device token to register.
 * @param info An NSDictionary containing registraton keys and values. See
 * http://urbanairship.com/docs/push.html#registration for details.
 */
- (void)registerDeviceToken:(NSData *)token withExtraInfo:(NSDictionary *)info{

}

/**
 * Remove this device token's registration from the server.
 * This call is equivalent to an API DELETE call, as described here:
 * http://urbanairship.com/docs/push.html#registration
 *
 * Add a FARegistrationObserver to FACloud to receive success or failure callbacks.
 */
- (void)unRegisterDeviceToken{

}

@end
