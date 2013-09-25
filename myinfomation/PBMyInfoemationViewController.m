//
//  PBMyInfoemationViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#import "PBMyInfoemationViewController.h"
#import "PBInvestmentCaseViewController.h"
#import "Personal.h"
#import "PBUserModel.h"
@implementation PBMyInfoemationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
//    PBInvestmentCaseViewController *investmentCaseVC = [[[PBInvestmentCaseViewController alloc] init] autorelease];
//    PBNavigationController *oneNav = [[PBNavigationController alloc] initWithRootViewController:investmentCaseVC];
//    investmentCaseVC.title = @"投资案例";
//    
//    InfoMG *informationManagementVC= [[[InfoMG alloc] init] autorelease];
//    PBNavigationController *twoNav = [[PBNavigationController alloc] initWithRootViewController:informationManagementVC];
////    informationManagementVC.title = @"信息管理";
//    informationManagementVC.flag = @"info";
//    if ([PBUserModel getPasswordAndKind].kind == 1) {
//        informationManagementVC.buttontext = [NSArray arrayWithObjects:@"我们的评论",@"我的微博回复",@"商业计划书",@"企业融资需求",@"企业理财需求",@"金融项目",@"金融资讯收藏",@"金融产品收藏",@"金融案例收藏",@"金融政策收藏",@"金融专栏",@"我的私信",@"关注我", nil];
//    }
//    if ([PBUserModel getPasswordAndKind].kind == 3) {
//        informationManagementVC.buttontext = [NSArray arrayWithObjects:@"我们的评论",@"我的微博回复",@"提问回答",@"企业融资需求",@"企业理财需求",@"金融项目",@"金融资讯收藏",@"金融产品收藏",@"金融案例收藏",@"金融政策收藏", @"金融专栏",@"我的私信",@"关注我",nil];
//    }
//    Personal *personalSettingsVC = [[[Personal alloc] init] autorelease];
//    personalSettingsVC.flag = @"setting";
//    PBNavigationController *threeNav = [[PBNavigationController alloc] initWithRootViewController:personalSettingsVC];
//    personalSettingsVC.title = @"个人设置";
//    
//    
//    
//    super.tabBarItems = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:twoNav, @"viewController", @"xinxiguanli.png", @"image",@"信息管理", @"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:oneNav, @"viewController", @"touzianli.png", @"image", @"投资案例", @"title",nil],[NSDictionary dictionaryWithObjectsAndKeys:threeNav, @"viewController", @"shezhi.png", @"image",@"个人设置", @"title", nil],  nil];
//    self.viewControllers = [NSArray arrayWithObjects:twoNav,oneNav,threeNav, nil];
//    [super customButtomItem:informationManagementVC];
//    [super customButtomItem:investmentCaseVC];
//    [super customButtomItem:personalSettingsVC];
//    [oneNav release];
//    [twoNav release];
//    [threeNav release];
//    [super viewDidLoad];
}

//返回home界面
- (void)backHomeController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
