//
//  PBMainFinanceProductController.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainFinanceProductController.h"
#import "PBFinanceProductList.h"
#import "PBFinanceAuctionList.h"
#import "PBIndustryOpportunityList.h"
@interface PBMainFinanceProductController ()

@end

@implementation PBMainFinanceProductController

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
    PBFinanceProductList* recommend = [[[PBFinanceProductList alloc]init]autorelease];
    PBIndustryOpportunityList* allproduct = [[[PBIndustryOpportunityList alloc]init]autorelease];
    PBFinanceAuctionList* auction = [[[PBFinanceAuctionList alloc]init]autorelease];
    recommend.navigationItem.title = @"金融团购预约";
    allproduct.navigationItem.title = @"行业商机";
    auction.navigationItem.title = @"拍卖预约";
    recommend.rootController = self;
    allproduct.rootController = self;
    auction.rootController = self;
    PBNavigationController *nsuper = [[PBNavigationController alloc]initWithRootViewController:recommend];
    PBNavigationController *nshow = [[PBNavigationController alloc]initWithRootViewController:allproduct];
    PBNavigationController *nsearch = [[PBNavigationController alloc]initWithRootViewController:auction];
    [super customButtomItem:recommend];
    [super customButtomItem:allproduct];
    [super customButtomItem:auction];
    self.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:nsearch, @"viewController", @"product_auction.png", @"image", nil],[NSDictionary dictionaryWithObjectsAndKeys:nsuper, @"viewController", @"product_tuijian.png", @"image", nil], [NSDictionary dictionaryWithObjectsAndKeys:nshow, @"viewController", @"product_licai.png", @"image", nil], nil] retain];
    [nsuper        release];
    [nshow    release];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
