//
//  PBBusinessCollegeMainNV.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBusinessCollegeMainNV.h"
#import "PBClassroomVC.h"
#import "PBPublicTrainingVC.h"
#import "PBHighCourseVC.h"
@interface PBBusinessCollegeMainNV ()

@end

@implementation PBBusinessCollegeMainNV
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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    PBPublicTrainingVC* pbPublicTrainingVC = [[[PBPublicTrainingVC alloc] init]autorelease];
    PBNavigationController *PublicTrainingNV = [[PBNavigationController alloc]initWithRootViewController:pbPublicTrainingVC];

    pbPublicTrainingVC.title = @"公益培训";
    [PublicTrainingNV.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    PublicTrainingNV.navigationBar.barStyle = UIBarStyleBlack;
    [PublicTrainingNV.tabBarItem setImage:[UIImage imageNamed:@"PublicTraining.png"]];
    
    
    
    PBHighCourseVC* pbHighCourseVC = [[[PBHighCourseVC alloc]init]autorelease];
    PBNavigationController *HighCourseNV = [[PBNavigationController alloc]initWithRootViewController:pbHighCourseVC];

    pbHighCourseVC.title = @"高端课程";
    [HighCourseNV.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    HighCourseNV.navigationBar.barStyle = UIBarStyleBlack;
    [HighCourseNV.tabBarItem setImage:[UIImage imageNamed:@"Knowledge.png"]];

    
    
    /*
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:PublicTrainingNV, @"viewController", @"PublicTraining.png", @"image",@"公益培训",@"title", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:HighCourseNV, @"viewController", @"Knowledge.png", @"image",@"高端课程",@"title", nil],

                         nil];
     [super customButtomItem:pbPublicTrainingVC];
     [super customButtomItem:pbHighCourseVC];
     */

    self.viewControllers = [NSArray arrayWithObjects:PublicTrainingNV,HighCourseNV, nil];
    [self backItem:pbHighCourseVC];
    [self backItem:pbPublicTrainingVC];

     
     [PublicTrainingNV        release];
     [HighCourseNV        release];
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
