//
//  FAMainChatController.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-4-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAMainChatController.h"
#import "FACompanyInfoView.h"
#import "FAChatSettingView.h"
#import "FAFriendController.h"
#import "FAGroupListView.h"
#import "FAFriendListView.h"
#import "FAChatView.h"

@interface FAMainChatController ()

@end

@implementation FAMainChatController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    FAFriendListView* friendList=[[[FAFriendListView alloc] init] autorelease];
    FAGroupListView* groupList=[[[FAGroupListView alloc] init] autorelease];
    FAChatView* chatView=[[[FAChatView alloc] init] autorelease];
    UINavigationController *navigation1=[[UINavigationController alloc]initWithRootViewController:chatView];
    UINavigationController *navigation2=[[UINavigationController alloc] initWithRootViewController:friendList];
    UINavigationController *navigation3=[[UINavigationController alloc]initWithRootViewController:groupList];
    [groupList setAddGroupView];
    super.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:navigation1, @"viewController", @"tab1_normal.png", @"image",@"会话", @"title", nil], [NSDictionary dictionaryWithObjectsAndKeys:navigation2, @"viewController", @"friend_info_add.png", @"image",@"我的好友", @"title", nil], [NSDictionary dictionaryWithObjectsAndKeys:navigation3, @"viewController", @"grouplist.png", @"image",@"我的群组", @"title", nil], nil] retain];
    self.viewControllers = [NSArray arrayWithObjects:navigation1,navigation2,navigation3, nil];
    [super customButtomItem:chatView];
    [super customButtomItem:friendList];
    [super customButtomItem:groupList];
//    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
