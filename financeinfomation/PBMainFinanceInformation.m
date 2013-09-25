//
//  PBMainFinanceInformation.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainFinanceInformation.h"
#import "PBFinancalPolicyController.h"
#import "PBFinanceNewsListView.h"
#import "PBFinancalProductsController.h"
#import "PBFinancingCaseController.h"
#import "PBAboutUsView.h"
@interface PBMainFinanceInformation ()

@end

@implementation PBMainFinanceInformation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        PBAboutUsView* aboutus = [[PBAboutUsView alloc]init];
//        PBNavigationController *usNav = [[PBNavigationController alloc] initWithRootViewController:aboutus];
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PBFinancalPolicyController *policyController = [[[PBFinancalPolicyController alloc] init] autorelease];
    policyController.flag = 1;
    PBNavigationController *policyNav = [[PBNavigationController alloc] initWithRootViewController:policyController];
    
    PBFinancalProductsController *productsController = [[[PBFinancalProductsController alloc] init] autorelease];
    PBNavigationController *productsNav = [[PBNavigationController alloc] initWithRootViewController:productsController];
    productsController.rootController = self;
    productsController.flag = 1;
    PBFinancingCaseController *caseController = [[[PBFinancingCaseController alloc] init] autorelease];
    PBNavigationController *caseNav = [[PBNavigationController alloc] initWithRootViewController:caseController];
    caseController.flag = 1;
    
    
    
    super.tabBarItems = [[NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:productsNav, @"viewController", @"financproduct.png", @"image",@"金融产品",@"title", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:caseNav, @"viewController", @"financingcase.png", @"image", NSLocalizedString(@"_title_cpfwxxxx", nil),@"title",nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:policyNav, @"viewController", @"financpolicy.png", @"image",@"金融政策",@"title", nil], nil] retain];
    [policyNav      release];
    [productsNav    release];
    [caseNav        release];
    //        [usNav release];
    self.viewControllers = [NSArray arrayWithObjects:productsNav,caseNav,policyNav, nil];
    //        [super customButtomItem:aboutus];
    [super customButtomItem:policyController];
    [super customButtomItem:productsController];
    [super customButtomItem:caseController];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
