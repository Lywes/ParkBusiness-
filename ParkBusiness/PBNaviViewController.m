//
//  PBNaviViewController.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-4-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBNaviViewController.h"



@interface PBNaviViewController ()

@end

@implementation PBNaviViewController
//@synthesize tabBar;
@synthesize tabBarItems;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bottomtabbar.png"]];
//        self.tabBar.tintColor = [UIColor greenColor];
        tag = 0;
    }
    return self;
}

- (UIViewController *) customButtomItem:(UIViewController *) viewController
{
    NSLog(@"%@",viewController.navigationController);
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    viewController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    viewController.navigationItem.leftBarButtonItem = barButton;
    for (NSDictionary* dic in self.tabBarItems) {
        PBNavigationController* navi = (PBNavigationController*)[dic objectForKey:@"viewController"];
        if ([navi isEqual: viewController.navigationController]) {
//            [navi.tabBarItem setImage:[dic objectForKey:@"image"]];
            viewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:[dic objectForKey:@"title"] image:[UIImage imageNamed:[dic objectForKey:@"image"]] tag:tag++];
        }
    }
    return viewController;
}

- (void) backHomeView {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    float width = isPad() ? 768 : 320;
//    
//    self.tabBar = [[CustomTabBar alloc] initWithItemCount:self.tabBarItems.count itemSize:CGSizeMake(width/self.tabBarItems.count, KTabBarHeight) tag:0 delegate:self];
//    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottomtabbar.png"]];
//    self.tabBar.delegate = self;
//    // Place the tab bar at the bottom of our view(0,416,320,44)
//    self.tabBar.frame = CGRectMake(0,self.view.frame.size.height-KTabBarHeight,self.view.frame.size.width, KTabBarHeight);
//    [self.view addSubview:self.tabBar];
//    
//    // Select the first tab
//    [self.tabBar selectItemAtIndex:0];
//    [self touchDownAtItemAtIndex:0];
//    [self setNavigationBarStyle:self.tabBarItems];
//    [self setTabBarStyle:self.tabBarItems];
}
-(void)setNavigationBarStyle:(NSArray*)arr{
    for (NSDictionary* dic in arr) {
        PBNavigationController* navi = (PBNavigationController*)[dic objectForKey:@"viewController"];
        navi.navigationBar.barStyle = UIBarStyleBlack;
    }
    
}
-(void)setTabBarStyle:(NSArray*)arr{
    
}
-(void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex{
    
}
#pragma mark -
#pragma mark CustomTabBarDelegate

- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex
{
    // Get the right data
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return [UIImage imageNamed:[data objectForKey:@"image"]];
}
- (NSString *) titleFor:(CustomTabBar *)tabBar atIndex:(NSUInteger)itemIndex
{
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    return  [data objectForKey:@"title"];
}
- (UIImage*) backgroundImage
{
    // The tab bar's width is the same as our width(320)
    //    CGFloat width = self.view.frame.size.width;
    
    
    // Create a new image context
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, KTabBarHeight), NO, 0.0);
    
    //创建一个内容可拉伸，而边角不拉伸的图片
    //    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    //    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
    //    [[UIColor blackColor] set];
    //    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
    return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}


// This is the embossed-like image shown around a selected tab bar item
- (UIImage*) selectedItemImage
{
    // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
    CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/tabBarItems.count, KTabBarHeight);
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    
    // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
    [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2] drawInRect:CGRectMake(0, 2.0, tabBarItemSize.width, tabBarItemSize.height- 2.0)];
    
    // Generate a new image
    UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selectedItemImage;
}

////可更改跟随按钮滑动的小图标
- (UIImage*) tabBarArrowImage
{
    return [UIImage imageNamed:@"TabBarNipple.png"];
}
- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    UIViewController* viewController = [data objectForKey:@"viewController"];
    viewController.view.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height- KTabBarHeight);
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
//    [self.view insertSubview:viewController.view belowSubview:tabBar];
}



- (void) dealloc
{
//    [tabBar release];
    [tabBarItems release];
    [super dealloc];
}
- (void)viewDidUnload
{
//    [self setTabBar:nil];
    [self setTabBarItems:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

