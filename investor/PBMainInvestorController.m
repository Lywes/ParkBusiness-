//
//  PBMainInvestorController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainInvestorController.h"
#import "PBFinancInstitutController.h"
#import "PBInvestorController.h"
#import "PBAllInvestorController.h"


@interface PBMainInvestorController ()

@end

@implementation PBMainInvestorController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PBFinancInstitutController *finacInstitutController = [[[PBFinancInstitutController alloc] init] autorelease];
        PBNavigationController *finacInstitutNav = [[PBNavigationController alloc] initWithRootViewController:finacInstitutController];
        finacInstitutController.rootController = self;
        PBInvestorController *investorController = [[[PBInvestorController alloc] init] autorelease];
        PBNavigationController *investorNav = [[PBNavigationController alloc] initWithRootViewController:investorController];
        
        PBAllInvestorController *allInvestorController = [[[PBAllInvestorController alloc] init] autorelease];
        PBNavigationController *allInvestorNav = [[PBNavigationController alloc] initWithRootViewController:allInvestorController];
        
        [super customButtomItem:finacInstitutController];
        [super customButtomItem:investorController];
        [super customButtomItem:allInvestorController];
        
        super.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:finacInstitutNav, @"viewController", @"financinginstitution.png", @"image", nil], [NSDictionary dictionaryWithObjectsAndKeys:investorNav, @"viewController", @"recommend.png", @"image", nil], [NSDictionary dictionaryWithObjectsAndKeys:allInvestorNav, @"viewController", @"allinvestor.png", @"image", nil], nil] retain];
        [finacInstitutNav    release];
        [investorNav         release];
        [allInvestorNav      release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) dealloc
{
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
