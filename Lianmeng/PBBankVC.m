//
//  PBBankVC.m
//  PBBank
//
//  Created by lee lywes on 13-5-6.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import "PBBankVC.h"
#import "PBfuwutiandiVC.h"
#import "PBhuodonghuiguVC.h"
#import "PBhuodongyugaoVC.h"
#import "PBParkQAViewController.h"
#import "PBParkMicroblogViewController.h"
@interface PBBankVC ()

@end

@implementation PBBankVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PBfuwutiandiVC *fuwutiandi = [[[PBfuwutiandiVC alloc]initWithStyle:UITableViewStyleGrouped]autorelease];
        PBhuodongyugaoVC *huodonghuigu = [[[PBhuodongyugaoVC alloc]init]autorelease];
        huodonghuigu.title = @"活动回顾";
        huodonghuigu.stylename = @"huigu";
        PBhuodongyugaoVC *huodongyugao = [[[PBhuodongyugaoVC alloc]init]autorelease];
        huodongyugao.title = @"活动预告";
        PBParkMicroblogViewController *lianmeng = [[[PBParkMicroblogViewController alloc]init]autorelease];
        lianmeng.title = @"联盟微博";
        PBParkQAViewController *rongziqa = [[[PBParkQAViewController alloc] initWithNibName:isPad()?@"PBParkQAViewController_pad":@"PBParkQAViewController" bundle:nil] autorelease];
        rongziqa.title = @"融资Q/A";
        PBNavigationController *n1 = [[PBNavigationController alloc]initWithRootViewController:huodongyugao];
        PBNavigationController *n2 = [[PBNavigationController alloc]initWithRootViewController:huodonghuigu];
        PBNavigationController *n3 = [[PBNavigationController alloc]initWithRootViewController:fuwutiandi];
        PBNavigationController *n4 = [[PBNavigationController alloc]initWithRootViewController:rongziqa];
        PBNavigationController *n5 = [[PBNavigationController alloc]initWithRootViewController:lianmeng];
        
        
        [super customButtomItem:huodongyugao];
        [super customButtomItem:huodonghuigu];
        [super customButtomItem:fuwutiandi];
        [super customButtomItem:rongziqa];
        [super customButtomItem:lianmeng];
        
        super.tabBarItems = [[NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjectsAndKeys:n1, @"viewController", @"starcompany.png", @"image", nil], 
                              [NSDictionary dictionaryWithObjectsAndKeys:n2, @"viewController", @"category.png", @"image", nil], 
                              [NSDictionary dictionaryWithObjectsAndKeys:n3, @"viewController", @"newestcompany.png", @"image", nil], 
                              [NSDictionary dictionaryWithObjectsAndKeys:n4, @"viewController", @"search.png", @"image", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:n5, @"viewController", @"search.png", @"image", nil], nil] retain];
        [n1  release];
        [n2  release];
        [n3  release];
        [n4  release];
        [n5  release];    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
