//
//  AppDelegate.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-2-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "AppDelegate.h"
#import "DBAccess.h"
#import "PBUserModel.h"
#import "PBSidebarVC.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#define LOGINTIME [NSString stringWithFormat:@"%@/admin/index/logined",HOST]
@interface AppDelegate (Private)


- (void) doBackgroundDownload:(int)index pushFlg:(int)push;
- (void) beingBackgroundUpdateTask;
- (void) endBackgroundUpdateTask;
@end
@implementation AppDelegate
@synthesize window = _window;
@synthesize backgroundUpdateTask;
@synthesize player;
@synthesize parkno;
- (void)dealloc
{
    [rootController_ release];
    [_window release];
    [super dealloc];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)theplayer successfully:(BOOL)flag{
	if (theplayer == self.player && flag == YES) {
//		NSLog(@"finished");
	}
}

-(void)setupPushWithOptions:(NSDictionary *)launchOptions {
    
    //#warning   SETUP YOUR PUSH NOTIFICATIONS
    //FACloud PUSH NOTIFICATION CONFIGURATION
    //Init Airship launch options
    NSMutableDictionary *cloudConfigOptions = [[NSMutableDictionary alloc] init] ;
    [cloudConfigOptions setValue:@"c17f28943446d7117a89e87bc1c45b22" forKey:@"DEVELOPMENT_APP_KEY"];
    [cloudConfigOptions setValue:@"4eb9a34b6f575f443b45e2f47fbd1dd4" forKey:@"DEVELOPMENT_APP_SECRET"];
    [cloudConfigOptions setValue:parkno forKey:@"PRODUCTION_APP_PARKNO"];
    [cloudConfigOptions setValue:@"c8e38d0acafa7dd5b7b81a96f2b54c55" forKey:@"PRODUCTION_APP_KEY"];
    [cloudConfigOptions setValue:@"17f12141a8ad688cd3296f55f198de34" forKey:@"PRODUCTION_APP_SECRET"];
    
#ifdef DEBUG
    [cloudConfigOptions setValue:@"NO" forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
#else
    [cloudConfigOptions setValue:@"YES" forKey:@"APP_STORE_OR_AD_HOC_BUILD"];
#endif
    
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init] ;
    [takeOffOptions setValue:launchOptions forKey:FACloudTakeOffOptionsLaunchOptionsKey];
    [takeOffOptions setValue:cloudConfigOptions forKey:FACloudTakeOffOptionsCloudConfigKey];
    [cloudConfigOptions release];
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please replace these with your info from http://go.urbanairship.com
    [FACloud takeOff:takeOffOptions];
    [takeOffOptions release];
    [[FAPush shared] resetBadge];//zero badge on startup
    [[FAPush shared] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNewsstandContentAvailability|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    // register Observer
    [[FAPush shared] addObserver:self];
    
    FAFriendListView *friendlist = [[[FAFriendListView alloc] init]autorelease];
    [[FAPush shared] addObserver:friendlist];
    
    FAGroupListView *grouplist = [[[FAGroupListView alloc] init]autorelease];
    [[FAPush shared] addObserver:grouplist];
    
    FAChatView *chatview = [[[FAChatView alloc] init]autorelease];
    [[FAPush shared] addObserver:chatview];
    
}
//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    return UIInterfaceOrientationMaskA;
//}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)initializePlat{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"3548074629"
                               appSecret:@"19d98e1c0b54b287dedf929495d25337"
                             redirectUri:@"http://www.softechallenger.com/investment/weibo/callback.php"];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx013ee45941ce7453" wechatCls:[WXApi class]];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    parkno = @"1";
    [ShareSDK registerApp:@"85410554574"];
    
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    //    [ShareSDK registerApp:@"api20" useAppTrusteeship:YES];
    
    //转换链接标记
    //    [ShareSDK convertUrlEnabled:YES];
    [self initializePlat];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after
    DBAccess* dbAccess = [[[DBAccess alloc] init]autorelease];
    [dbAccess copyDatabaseIfNeeded];
    if([PBUserModel isRegister]){
        PBWeiboDataConnect* insertData = [[PBWeiboDataConnect alloc] init];
        insertData.delegate = self;
        NSArray* arr1 = [NSArray arrayWithObjects:USERNO, nil];
        NSArray* arr2 = [NSArray arrayWithObjects:@"no", nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [insertData submitDataFromUrl:LOGINTIME postValuesAndKeys:dic];
        [dic release];
        PBSidebarVC* home = [[PBSidebarVC alloc] init];
        rootController_=[[UINavigationController alloc]initWithRootViewController:home];
    }else{
        if(isPad()){
            login = [[PBLoginController alloc]initWithNibName:@"PBLoginController_ipad" bundle:nil];
        }else{
            if(isPhone5()){
                login = [[PBLoginController alloc]initWithNibName:@"PBLoginController_i5" bundle:nil];
            }else{
                login = [[PBLoginController alloc]initWithNibName:@"PBLoginController" bundle:nil];
            }
            
        }
        rootController_=[[UINavigationController alloc]initWithRootViewController:login];
    }
    [UIApplication sharedApplication].statusBarHidden = YES;
    //[self.window addSubview:rootController_.view];
    self.window.rootViewController = rootController_;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupPushWithOptions:launchOptions];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    NSString *soundFilePath =
	[[NSBundle mainBundle] pathForResource: @"classic"
									ofType: @"mp3"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	AVAudioPlayer *newPlayer =
	[[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
										   error: nil];
	[fileURL release];
	self.player = newPlayer;
	[newPlayer release];
//	[self.player prepareToPlay];
	[self.player setDelegate: self];
	self.player.numberOfLoops = 1;    // 循环播放音频，直到调用Stop方法
    NSDictionary * userInfo = [launchOptions
                               objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSString * message = nil;
    
    NSDictionary * apsDict = [userInfo objectForKey:@"aps"];
    
    id alert = [apsDict objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]]) {
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        message = [alert objectForKey:@"body"];
    }
    NSLog(@"message =%@",message);
    // You may want to clear the notification badge
    application.applicationIconBadgeNumber = 0;
#ifdef DEBUG
    // For debugging - allow multiple pushes per day
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NKDontThrottleNewsstandContentNotifications"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
#endif
    return YES;
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    NSError* error;
    NSData* requestData = [weiboDatas.XMLDataRequest responseData];
    NSDictionary* loadDic = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableLeaves error:&error];
    NSString *str= [loadDic objectForKey:@"validflg"];
    if (![str isEqualToString:@"1"]) {
        int credit = [[loadDic objectForKey:@"credit"] intValue];
        [PBUserModel updateCredit:credit];
    }
    else{
        UIAlertView *aletview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的身份无效，你不能使用融商APP，如有疑问请联系管理员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aletview show];
        [aletview release];
        
        
    }
}
#pragma mark - alertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
    //     exit(0);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
//应用程序进入活动状态
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[FAPush shared] showInviteMessage];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[[[deviceToken description]
                                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Registered with device token: %@",deviceTokenString);
    [[FACloud shared] addObserver:self];
    [[FACloud shared] registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"failed to get token ,error:%@",error);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Received remote notification: %@", userInfo);
    
    
    
    if([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive) {
        [[FAPush shared] handleNotification:userInfo applicationState:application.applicationState];
        [[FAPush shared] resetBadge];
    }else if(isOS5()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self beingBackgroundUpdateTask];
            NSDictionary *aps = [userInfo objectForKey:@"aps"];
            int kind = [[aps objectForKey:@"kind"] intValue];
            NSLog(@"kind=%d",kind);
            if (kind ==2 || kind==3) {
                [self.player play];
            }
            // Do something with the result
            [[FAPush shared] handleNotification:userInfo applicationState:application.applicationState];
            [[FAPush shared] resetBadge];
            
            [self endBackgroundUpdateTask];
        });
        
    }
    
    
}
- (void) beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void) endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}
- (void)registerDeviceTokenSucceededAndSaveUserId:(NSString*)userId{
    FACloud *cloud = [FACloud shared];
    //保存到服务器
    FADataManager* dataManager = [[[FADataManager alloc]init]autorelease];
    dataManager.delegate =self;
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"id",cloud.deviceToken,@"identifier",parkno,@"parkno", nil];
    [dataManager writeWithFormatId:20 sendData:dic];
    [dic release];
}
-(void)saveData:(NSDictionary *)data primaryKey:(NSString *)key{
    FAUserData *user = [[[FAUserData alloc] init] autorelease];
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    user.no = [[key stringByTrimmingCharactersInSet:nonDigits] intValue];
    user.name = @"终端用户";
    FACloud *cloud = [FACloud shared];
    user.pushid = cloud.deviceToken;
    user.icon = [UIImage imageNamed:@"list_addfriend_icon.png"];
    user.parkno = [parkno intValue];
    PBUserModel* checkUser = [PBUserModel getPasswordAndKind];
    if(checkUser.password==nil||[checkUser.password length]==0){
        [user saveRecord];
    }
}
- (void)registerDeviceTokenFailedAndShowFailureReason:(NSString*)reason{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统错误" message:reason  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:reason];
    [alert show];
    [alert release];
}


-(void)messageAlert:(NSString*)message messageId:(int)messageId
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统消息" message:message  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)saveGroupInvite:(NSDictionary *)aps{
    FAInviteInfoData *inviteinfo = [[[FAInviteInfoData alloc]init] autorelease];
    inviteinfo.fromid = [[aps objectForKey:@"fromid"] intValue];
    inviteinfo.username = [aps objectForKey:@"username"];
    inviteinfo.groupid = [[aps objectForKey:@"gid"] intValue];
    inviteinfo.groupname = [aps objectForKey:@"groupname"];
    inviteinfo.alert = [aps objectForKey:@"alert"];
    inviteinfo.kind = 4;
    inviteinfo.flg = 0;
    [inviteinfo saveRecord];
}
- (void)saveFreindInvite:(NSDictionary *)aps{
    FAInviteInfoData *inviteinfo = [[[FAInviteInfoData alloc]init] autorelease];
    inviteinfo.fromid = [[aps objectForKey:@"fromid"] intValue];
    inviteinfo.username = [aps objectForKey:@"username"];
    inviteinfo.alert = [aps objectForKey:@"alert"];
    inviteinfo.kind = 6;
    inviteinfo.flg = 0;
    [inviteinfo saveRecord];
}
- (void)saveSystemMessage:(NSDictionary *)aps{
    FASystemMessageData *systemdata = [[[FASystemMessageData alloc]init]autorelease];
    systemdata.isread = 0;
    systemdata.formatid = [[aps objectForKey:@"formatid"] intValue];
    systemdata.content = [aps objectForKey:@"alert"];
    systemdata.createtime = [NSDate date];
    systemdata.object = [aps objectForKey:@"keyvalue"];
    [systemdata saveRecord];
}
@end
