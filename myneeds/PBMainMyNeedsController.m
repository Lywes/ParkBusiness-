//
//  PBMainMyNeedsController.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainMyNeedsController.h"
#import "PBMyFinanceNeedsList.h"
#import "PBMyManageMoneyNeedsList.h"
#import "PBIndustryOpportunityList.h"
@interface PBMainMyNeedsController ()

@end

@implementation PBMainMyNeedsController

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
    PBMyFinanceNeedsList *financeneed = [[[PBMyFinanceNeedsList alloc] init] autorelease];
    PBNavigationController *oneNav = [[PBNavigationController alloc] initWithRootViewController:financeneed];
    financeneed.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
    financeneed.rootViewController = self;
    PBMyManageMoneyNeedsList *managemoney = [[[PBMyManageMoneyNeedsList alloc] init] autorelease];
    PBNavigationController *twoNav = [[PBNavigationController alloc] initWithRootViewController:managemoney];
    managemoney.title = NSLocalizedString(@"Left_mainTable_LCXQ", nil);
    managemoney.rootViewController = self;
    PBIndustryOpportunityList* allproduct = [[[PBIndustryOpportunityList alloc]init]autorelease];
    allproduct.title = NSLocalizedString(@"Left_mainTable_QYGQ", nil);
    allproduct.rootController = self;
    PBNavigationController *nshow = [[PBNavigationController alloc]initWithRootViewController:allproduct];    
    super.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:oneNav, @"viewController", @"needs_finance.png", @"image",NSLocalizedString(@"Left_mainTable_RZXQ", nil), @"title", nil], [NSDictionary dictionaryWithObjectsAndKeys:twoNav, @"viewController", @"needs_licai.png", @"image", NSLocalizedString(@"Left_mainTable_LCXQ", nil), @"title",nil], [NSDictionary dictionaryWithObjectsAndKeys:nshow, @"viewController", @"product_licai.png", @"image", NSLocalizedString(@"Left_mainTable_QYGQ", nil), @"title",nil], nil] retain];
    self.viewControllers = [NSArray arrayWithObjects:oneNav,twoNav,nshow, nil];
    [super customButtomItem:financeneed];
    [super customButtomItem:allproduct];
    [super customButtomItem:managemoney];
    [oneNav release];
    [twoNav release];
    [nshow release];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
