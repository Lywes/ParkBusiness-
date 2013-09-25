//
//  PBMainAskSquareController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainAskSquareController.h"
#import "PBFinancalPolicyController.h"
#import "PBFinancalProductsController.h"
#import "PBFinancingCaseController.h"
#import "PBJoinCompaniesController.h"

@interface PBMainAskSquareController ()

@end

@implementation PBMainAskSquareController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PBFinancalPolicyController *policyController = [[[PBFinancalPolicyController alloc] init] autorelease];
        PBNavigationController *policyNav = [[PBNavigationController alloc] initWithRootViewController:policyController];
        
        PBFinancalProductsController *productsController = [[[PBFinancalProductsController alloc] init] autorelease];
        PBNavigationController *productsNav = [[PBNavigationController alloc] initWithRootViewController:productsController];
        
        PBFinancingCaseController *caseController = [[[PBFinancingCaseController alloc] init] autorelease];
        PBNavigationController *caseNav = [[PBNavigationController alloc] initWithRootViewController:caseController];
        
        PBJoinCompaniesController *joinCompanyController = [[[PBJoinCompaniesController alloc] init] autorelease];
        PBNavigationController *joinNav = [[PBNavigationController alloc] initWithRootViewController:joinCompanyController];
        joinCompanyController.flag = 1;
        [super customButtomItem:policyController];
        [super customButtomItem:productsController];
        [super customButtomItem:caseController];
        [super customButtomItem:joinCompanyController];
        
        super.tabBarItems = [[NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjectsAndKeys:joinNav, @"viewController", @"joincompany.png", @"image", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:productsNav, @"viewController", @"financproduct.png", @"image",nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:caseNav, @"viewController", @"financingcase.png", @"image",  nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:policyNav, @"viewController", @"financpolicy.png", @"image",  nil],   nil] retain];
        [policyNav      release];
        [productsNav    release];
        [caseNav        release];
        [joinNav      release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
