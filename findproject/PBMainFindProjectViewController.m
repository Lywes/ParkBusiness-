//
//  PBMainFindProjectViewController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainFindProjectViewController.h"
#import "PBRecommendProjectViewController.h"
#import "PBProjectCatedoryViewController.h"
#import "PBNewestProjectViewController.h"
#import "PBSearchProjectViewController.h"
#import "PBSpecificTradeController.h"
#define SELECTED_VIEW_CONTROLLER_TAG 98456345
#define KTabBarHeight 49.0

@interface PBMainFindProjectViewController ()

@end

@implementation PBMainFindProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PBRecommendProjectViewController *recommendController = [[[PBRecommendProjectViewController alloc] init] autorelease];
        PBNavigationController *recommendNav = [[PBNavigationController alloc] initWithRootViewController:recommendController];
        PBProjectCatedoryViewController *catedoryController = [[[PBProjectCatedoryViewController alloc] init] autorelease];
        PBNavigationController *catedoryNav = [[PBNavigationController alloc] initWithRootViewController:catedoryController];
        PBSpecificTradeController *newestController = [[[PBSpecificTradeController alloc] init] autorelease];
        PBNavigationController *newestNav = [[PBNavigationController alloc] initWithRootViewController:newestController];
        PBSearchProjectViewController *searchController = [[[PBSearchProjectViewController alloc] init] autorelease];
        PBNavigationController *searchNav = [[PBNavigationController alloc] initWithRootViewController:searchController];
        [super customButtomItem:recommendController];
        [super customButtomItem:catedoryController];
        [super customButtomItem:newestController];
        [super customButtomItem:searchController];
        
        super.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:recommendNav, @"viewController", @"recommendproject.png", @"image", nil], [NSDictionary dictionaryWithObjectsAndKeys:catedoryNav, @"viewController", @"category.png", @"image", nil], [NSDictionary dictionaryWithObjectsAndKeys:newestNav, @"viewController", @"newestproject.png", @"image", nil], [NSDictionary dictionaryWithObjectsAndKeys:searchNav, @"viewController", @"search.png", @"image", nil], nil] retain];
        [recommendNav        release];
        [catedoryNav    release];
        [newestNav      release];
        [searchNav      release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [super dealloc];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}
@end
