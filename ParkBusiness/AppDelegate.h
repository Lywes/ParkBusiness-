//
//  AppDelegate.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-2-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FACloud.h"
#import "FAPush.h"
#import "FAChatManager.h"
#import "FAUserData.h"
#import "FADataManager.h"
#import "FAInviteInfoData.h"
#import "FAFriendListView.h"
#import "FAGroupListView.h"
#import "FAChatView.h"
#import "FASystemMessageData.h"
#import <AVFoundation/AVFoundation.h>
#import "PBLoginController.h"
#import "PBWeiboDataConnect.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,FARegistrationObserver,FAPushNotificationObserver,AVAudioPlayerDelegate,FADataManagerDelegate,PBWeiboDataDelegate>{
    UINavigationController *rootController_;
    PBLoginController* login;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (nonatomic,retain,readwrite)AVAudioPlayer *player;
@property (nonatomic, retain) NSString* parkno;
-(void)messageAlert:(NSString*)message messageId:(int)messageId;
@end
