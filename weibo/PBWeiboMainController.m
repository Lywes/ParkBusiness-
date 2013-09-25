//
//  PBWeiboMainController.m
//  ParkBusiness
//
//  Created by QDS on 13-4-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWeiboMainController.h"
#import "PBShowWeiboController.h"
#import "PBSuperWeiboController.h"
@interface PBWeiboMainController ()

@end

@implementation PBWeiboMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad
{
    PBSuperWeiboController* superweibo = [[[PBSuperWeiboController alloc]init]autorelease];
    PBShowWeiboController* showweibo = [[[PBShowWeiboController alloc]init]autorelease];
    superweibo.tutorflag = @"1";
    showweibo.tutorflag = @"1";
    superweibo.navigationItem.title = @"推荐微博";
    showweibo.navigationItem.title = @"全部微博";
    PBNavigationController *nsuper = [[PBNavigationController alloc]initWithRootViewController:superweibo];
    PBNavigationController *nshow = [[PBNavigationController alloc]initWithRootViewController:showweibo];
    self.tabBarItems = [[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:nsuper, @"viewController", @"superweibo.png", @"image",@"推荐微博", @"title", nil], [NSDictionary dictionaryWithObjectsAndKeys:nshow, @"viewController", @"allweibo.png", @"image", @"全部微博", @"title",nil], nil] retain];
    self.viewControllers = [NSArray arrayWithObjects:nsuper,nshow, nil];
    [super customButtomItem:superweibo];
    [super customButtomItem:showweibo];
    [nsuper        release];
    [nshow    release];
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
