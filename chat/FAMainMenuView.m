//
//  FAMainMenuView.m
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-11-23.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import "FAMainMenuView.h"
#import "FACompanyInfoView.h"
#import "FAChatSettingView.h"
#import "FAFriendController.h"
#import "FAGroupListView.h"
#import "FAFriendListView.h"
#import "FAChatView.h"

@interface FAMainMenuView ()

@end

@implementation FAMainMenuView


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)showView
{
    UITabBarController* tab = [[UITabBarController alloc]init];
    FACompanyInfoView* companyInfo=[[[FACompanyInfoView alloc]init]autorelease];
    //FAChatSettingView* chatSetting=[[[FAChatSettingView alloc]init]autorelease];
    //FAFriendController* friendList=[[[FAFriendController alloc] init] autorelease];
    FAFriendListView* friendList=[[[FAFriendListView alloc] init] autorelease];
    FAGroupListView* groupList=[[[FAGroupListView alloc] init] autorelease];
    FAChatView* chatView=[[[FAChatView alloc] init] autorelease];
    
    
    navigation1=[[UINavigationController alloc]initWithRootViewController:chatView];
    navigation2=[[UINavigationController alloc] initWithRootViewController:friendList];
    navigation3=[[UINavigationController alloc]initWithRootViewController:groupList];
    navigation4=[[UINavigationController alloc]initWithRootViewController:companyInfo];
    
    NSArray* array=[[NSArray alloc]initWithObjects:navigation1,navigation2,navigation3,navigation4,nil];
   


     
    [tab setViewControllers:array];
    
    [self.navigationController pushViewController:tab animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
