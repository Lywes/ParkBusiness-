//
//  PBMainViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainViewController.h"
#import "PBParkEnvironmentViewController.h"
#import "PBIndustrialPolicyViewController.h"
#import "PBParkActivityViewController.h"
#import "PBParkQAViewController.h"
#import "PBParkMicroblogViewController.h"
#import "PBNewestEntrepreneurs.h"
@implementation PBMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    //定义五个tabbar标签。
    PBParkEnvironmentViewController *parkEnvironmentViewController = [[[PBParkEnvironmentViewController alloc] init] autorelease];
    PBNavigationController *oneNav = [[PBNavigationController alloc] initWithRootViewController:parkEnvironmentViewController];
    
    PBIndustrialPolicyViewController *industrialPolicyViewController = [[[PBIndustrialPolicyViewController alloc] init] autorelease];
    PBNavigationController *twoNav = [[PBNavigationController alloc] initWithRootViewController:industrialPolicyViewController];
    
    PBParkActivityViewController *parkActivityViewController = [[[PBParkActivityViewController alloc] init] autorelease];
    PBNavigationController *threeNav = [[PBNavigationController alloc] initWithRootViewController:parkActivityViewController];
    
    PBParkQAViewController *parkQAViewController = [[[PBParkQAViewController alloc] initWithNibName:isPad()?@"PBParkQAViewController_pad":@"PBParkQAViewController" bundle:nil] autorelease];
    PBNavigationController *fourNav = [[PBNavigationController alloc] initWithRootViewController:parkQAViewController];
    
    PBNewestEntrepreneurs *newestController = [[[PBNewestEntrepreneurs alloc] init] autorelease];
    PBNavigationController *newestNav = [[PBNavigationController alloc] initWithRootViewController:newestController];
    PBParkMicroblogViewController *parkMicroblogViewController = [[[PBParkMicroblogViewController alloc] init] autorelease];
    PBNavigationController *fiveNav = [[PBNavigationController alloc] initWithRootViewController:parkMicroblogViewController];
    //设置title
    parkEnvironmentViewController.title = @"园区环境";
    parkEnvironmentViewController.parentsController = self;
    industrialPolicyViewController.title = @"园区政策";
    parkActivityViewController.title = @"会议与活动";
    parkQAViewController.title = @"园区问答";
    parkMicroblogViewController.title = @"园区微博";
    newestController.title = @"园区会员";
    //设置园区编号
    NSString* parkno = [NSString stringWithFormat:@"%d",[PBUserModel getParkNo]];
    parkEnvironmentViewController.parkNoString = parkno;
    industrialPolicyViewController.parkNoString = parkno;
    super.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:oneNav, @"viewController", @"yuanquhuanjing.png", @"image", @"园区环境", @"title",nil], [NSDictionary dictionaryWithObjectsAndKeys:threeNav, @"viewController", @"yuanquhuodong.png", @"image",@"会议与活动", @"title", nil], [NSDictionary dictionaryWithObjectsAndKeys:newestNav, @"viewController", @"newestcompany.png", @"image",@"园区会员", @"title", nil], [NSDictionary dictionaryWithObjectsAndKeys:twoNav, @"viewController", @"chanyezhengce.png", @"image", @"园区政策", @"title",nil],[NSDictionary dictionaryWithObjectsAndKeys:fiveNav, @"viewController", @"yuanquweibo.png", @"image",@"园区微博", @"title", nil],nil] retain];
    self.viewControllers = [NSArray arrayWithObjects:oneNav,threeNav,newestNav,twoNav,fiveNav, nil];
    [super customButtomItem:parkEnvironmentViewController];
    [super customButtomItem:parkActivityViewController];
    [super customButtomItem:newestController];
    [super customButtomItem:industrialPolicyViewController];
    [super customButtomItem:parkMicroblogViewController];
    [oneNav release];
    [twoNav release];
    [threeNav release];
    [fourNav release];
    [fiveNav release];
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
