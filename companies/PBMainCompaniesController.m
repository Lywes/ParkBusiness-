//
//  PBMainCompaniesController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMainCompaniesController.h"
//#import "PBStarEntrepreneurs.h"
#import "PBJoinCompaniesController.h"
#import "PBSectoralEntrepreneurs.h"
#import "PBNewestEntrepreneurs.h"
#import "PBSearchEntrepreneurs.h"
@interface PBMainCompaniesController ()

@end

@implementation PBMainCompaniesController

//- (void) awakeFromNib
//{
//    
//}
- (void) backItem:(UIViewController *) viewController
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    viewController.navigationItem.leftBarButtonItem = barButton;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {


        
        /*
        super.tabBarItems = [NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:joinNav, @"viewController", @"joincompany.png", @"image",@"加盟园区", @"title", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:sectoralNav, @"viewController", @"category.png", @"image",@"行业分类", @"title", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:searchNav, @"viewController", @"search.png", @"image",@"搜索企业家", @"title", nil],
                             nil];
        [super customButtomItem:joinCompanyController];
        [super customButtomItem:sectoralController];
        [super customButtomItem:searchController];
         
        */
        PBJoinCompaniesController *joinCompanyController = [[[PBJoinCompaniesController alloc] init] autorelease];
        PBNavigationController *joinNav = [[PBNavigationController alloc] initWithRootViewController:joinCompanyController];
        
        PBSectoralEntrepreneurs *sectoralController = [[[PBSectoralEntrepreneurs alloc] init] autorelease];
        PBNavigationController *sectoralNav = [[PBNavigationController alloc] initWithRootViewController:sectoralController];
        
        PBSearchEntrepreneurs *searchController = [[[PBSearchEntrepreneurs alloc] init] autorelease];
        PBNavigationController *searchNav = [[PBNavigationController alloc] initWithRootViewController:searchController];
        
//        PBNewestEntrepreneurs *newestController = [[[PBNewestEntrepreneurs alloc] init] autorelease];
//        PBNavigationController *newestNav = [[PBNavigationController alloc] initWithRootViewController:newestController];
        

        
        [joinNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        joinNav.navigationBar.barStyle = UIBarStyleBlack;
         joinCompanyController.title = @"加盟园区";
        [joinNav.tabBarItem setImage:[UIImage imageNamed:@"joincompany.png"]];
        
        [sectoralNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        sectoralNav.navigationBar.barStyle = UIBarStyleBlack;
        sectoralController.title = @"行业分类";
        [sectoralNav.tabBarItem setImage:[UIImage imageNamed:@"category.png"]];
        
        
        [searchNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        searchNav.navigationBar.barStyle = UIBarStyleBlack;
         searchController.title = @"搜索企业家";
        NSLog(@"%@",searchController.tabBarItem);
        [searchNav.tabBarItem setImage:[UIImage imageNamed:@"search.png"]];
        
        
        [self backItem:joinCompanyController];
        [self backItem:sectoralController];
        [self backItem:searchController];
        
        self.viewControllers = [NSArray arrayWithObjects:joinNav,sectoralNav,searchNav, nil];
        [joinNav        release];
        [sectoralNav    release];
        [searchNav      release];
//        [newestNav      release];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void) dealloc
{
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
